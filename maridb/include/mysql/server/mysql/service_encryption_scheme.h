#ifndef MYSQL_SERVICE_ENCRYPTION_SCHEME_INCLUDED
/* Copyright (c) 2015, MariaDB

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; version 2 of the License.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1335  USA */

/**
  @file
  encryption scheme service

  A higher-level access to encryption service.

  This is a helper service that storage engines use to encrypt tables on disk.
  It requests keys from the plugin, generates temporary or local keys
  from the global (as returned by the plugin) keys, etc.

  To use the service:

  * st_encryption_scheme object is created per space. A "space" can be
    a table space in XtraDB/InnoDB, a file in Aria, etc.  The whole
    space is encrypted with the one key id.

  * The service does not take the key and the IV as parameters for
    encryption or decryption. Instead it takes two 32-bit integers and
    one 64-bit integer (and requests the key from an encryption
    plugin, if needed).

  * The service requests the global key from the encryption plugin
    automatically as needed. Three last keys are cached in the
    st_encryption_scheme. Number of key requests (number of cache
    misses) are counted in st_encryption_scheme::keyserver_requests

  * If an st_encryption_scheme can be used concurrently by different
    threads, it needs to be able to lock itself when accessing the key
    cache.  Set the st_encryption_scheme::locker appropriately. If
    non-zero, it will be invoked by encrypt/decrypt functions to lock
    and unlock the scheme when needed.

  * Implementation details (in particular, key derivation) are defined
    by the scheme type. Currently only schema type 1 is supported.

  In the schema type 1, every "space" (table space in XtraDB/InnoDB,
  file in Aria) is encrypted with a different space-local key:

  * Every space has a 16-byte unique identifier (typically it's
    generated randomly and stored in the space). The caller should
    put it into st_encryption_scheme::iv.

  * Space-local key is generated by encrypting this identifier with
    the global encryption key (of the given id and version) using AES_ECB.

  * Encryption/decryption parameters for a page are typically the
    4-byte space id, 4-byte page position (offset, page number, etc),
    and the 8-byte LSN. This guarantees that they'll be different for
    any two pages (of the same or different tablespaces) and also that
    they'll change for the same page when it's modified. They don't need
    to be secret (they create the IV, not the encryption key).
*/

#ifdef __cplusplus
extern "C" {
#endif

#define ENCRYPTION_SCHEME_KEY_INVALID    -1
#define ENCRYPTION_SCHEME_BLOCK_LENGTH   16

struct st_encryption_scheme_key {
  unsigned int version;
  unsigned char key[ENCRYPTION_SCHEME_BLOCK_LENGTH];
};

struct st_encryption_scheme {
  unsigned char iv[ENCRYPTION_SCHEME_BLOCK_LENGTH];
  struct st_encryption_scheme_key key[3];
  unsigned int keyserver_requests;
  unsigned int key_id;
  unsigned int type;

  void (*locker)(struct st_encryption_scheme *self, int release);
};

extern struct encryption_scheme_service_st {
  int (*encryption_scheme_encrypt_func)
                               (const unsigned char* src, unsigned int slen,
                                unsigned char* dst, unsigned int* dlen,
                                struct st_encryption_scheme *scheme,
                                unsigned int key_version, unsigned int i32_1,
                                unsigned int i32_2, unsigned long long i64);
  int (*encryption_scheme_decrypt_func)
                               (const unsigned char* src, unsigned int slen,
                                unsigned char* dst, unsigned int* dlen,
                                struct st_encryption_scheme *scheme,
                                unsigned int key_version, unsigned int i32_1,
                                unsigned int i32_2, unsigned long long i64);
} *encryption_scheme_service;

#ifdef MYSQL_DYNAMIC_PLUGIN

#define encryption_scheme_encrypt(S,SL,D,DL,SCH,KV,I32,J32,I64) encryption_scheme_service->encryption_scheme_encrypt_func(S,SL,D,DL,SCH,KV,I32,J32,I64)
#define encryption_scheme_decrypt(S,SL,D,DL,SCH,KV,I32,J32,I64) encryption_scheme_service->encryption_scheme_decrypt_func(S,SL,D,DL,SCH,KV,I32,J32,I64)

#else

int encryption_scheme_encrypt(const unsigned char* src, unsigned int slen,
                              unsigned char* dst, unsigned int* dlen,
                              struct st_encryption_scheme *scheme,
                              unsigned int key_version, unsigned int i32_1,
                              unsigned int i32_2, unsigned long long i64);
int encryption_scheme_decrypt(const unsigned char* src, unsigned int slen,
                              unsigned char* dst, unsigned int* dlen,
                              struct st_encryption_scheme *scheme,
                              unsigned int key_version, unsigned int i32_1,
                              unsigned int i32_2, unsigned long long i64);

#endif


#ifdef __cplusplus
}
#endif

#define MYSQL_SERVICE_ENCRYPTION_SCHEME_INCLUDED
#endif
