const axios = require('axios');
const qs = require('query-string');
const key = require('../config/key');

class Papago {
    lookup(source, target, term) {
        // 메세지가 없을 경우 throw 처리.
        if (term == null) {
          // '검색 용어 조회 인수로 제공되어야 합니다.'
            throw new Error('Search term should be provided as lookup arguments');
        } else if (source == target) {
            // 'source 언어와 target 언어는 달라야합니다.'
            return term;
        }

        const config = {
            headers: {
                'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'x-naver-client-id': key.NAVER_CLIENT_ID,
                'x-naver-client-secret': key.NAVER_CLIENT_SECRET,
            },
        };
        const params = qs.stringify({
            source: source,
            target: target,
            text: term
        });
        const response = axios.post('https://openapi.naver.com/v1/papago/n2mt', params, config);

        return response.data.message.result.translatedText;
    }
}

module.exports = new Papago();