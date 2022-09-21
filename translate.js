// promise = 비동기적 처리 = 다중 작업 || 요청을 보낼때 응답 상태와 상관없이 다음 동작을 수행함. 즉, A작업이 시작되었을 때 동시에 B작업이 실행되며, A작업은 결과 값이 나오는대로 출력됨.
// async = function 앞에 async를 붙이면 promise 객체로 인식됨.
// await = promise 객체를 호출하는 함수 앞에 붙이면 데이터를 가져오는 것이 완료될 때까지 기다림.
// constructor = 생성자.

const axios = require('axios');
const qs = require('query-string');

class Papago {
    constructor(config) {
        this.config = config;
    }

    async lookup(term) {
        if (this.config == null) {
          // '먼저 구성을 사용하여 Papago 인스턴스를 초기화해야 합니다.'
            throw new Error('Papago instance should be initialized with config first');
        } if (term == null) {
          // '검색 용어 조회 인수로 제공되어야 합니다.'
            throw new Error('Search term should be provided as lookup arguments');
        }

        const params = qs.stringify({
            source: 'ko',
            target: 'en',
            text: term,
        });

        const config = {
            headers: {
                'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'x-naver-client-id': this.config.NAVER_CLIENT_ID,
                'x-naver-client-secret': this.config.NAVER_CLIENT_SECRET,
            },
        };

        const response = await axios.post('https://openapi.naver.com/v1/papago/n2mt', params, config);

        return response.data.message.result.translatedText;
    }
}

async function main() {
    const papago = new Papago({
        NAVER_CLIENT_ID: '9vx_e0D3S6lFhXCHHi73',
        NAVER_CLIENT_SECRET: '3k3oxC22Hp',
    });

    const nmtResult = await papago.lookup('안녕, 우람. 반가워.');
    console.log(nmtResult);
}

main();