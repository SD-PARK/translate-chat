const axios = require('axios');
const qs = require('query-string');
const key = require('./config/key');

class Papago {
    async lookup(target, term) {
        // 메세지가 없을 경우 throw 처리.
        if (term == null) {
          // '검색 용어 조회 인수로 제공되어야 합니다.'
            throw new Error('Search term should be provided as lookup arguments');
        }

        const config = {
            headers: {
                'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'x-naver-client-id': key.NAVER_CLIENT_ID,
                'x-naver-client-secret': key.NAVER_CLIENT_SECRET,
            },
        };
        
        // 언어 감지
        let params = qs.stringify({ query: term });
        const source = await axios.post('https://openapi.naver.com/v1/papago/detectLangs', params, config);
        const langCode = source.data.langCode;
        console.log('[langCode: ' + langCode + '] -> [trgtCode: ' + target + ']');

        if (langCode == target) {
            // 'source 언어와 target 언어는 달라야합니다.'
            throw new Error('The source language and the target language must be different.');
        }

        // 감지한 언어 기준으로 번역
        params = qs.stringify({
            source: langCode,
            target: target,
            text: term
        });
        const response = await axios.post('https://openapi.naver.com/v1/papago/n2mt', params, config);

        return response.data.message.result.translatedText;
    }
}

module.exports = new Papago();