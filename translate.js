// 실행 안 됨.

var express = require('express');
var app = express();
var client_id = '9vx_e0D3S6lFhXCHHi73';
var client_secret = '3k3oxC22Hp';
var query = "번역할 문장을 입력하세요.";
app.get('/translate', function (req, res) {
   var api_url = 'https://openapi.naver.com/v1/papago/n2mt';
   // request 모듈은 2020년 2월 11일 부로 deprecated 되었음.
   // 다른 패키지 사용할 것.
   var request = require('request');
   var options = {
       url: api_url,
       // source: 원본 언어의 언어 코드, target: 목적 언어의 언어 코드, text: 번역할 텍스트(1회 호출 시 최대 5,000자)
       form: {'source':'ko', 'target':'en', 'text':query},
       // X-Naver-Client-Id: 발급받은 클라이언트 아이디 값, X-Naver-Client-Secret: 발급받은 클라이언트 시크릿 값
       headers: {'X-Naver-Client-Id':client_id, 'X-Naver-Client-Secret': client_secret}
    };
    // request 객체의 post를 이용하여 options 인자를 통해 API를 호출한다.
   request.post(options, function (error, response, body) {
    // response.statusCode == 200: HTTP 요청이 성공했음을 나타내는 서버측 응답 상태 코드
     if (!error && response.statusCode == 200) {
       res.writeHead(200, {'Content-Type': 'text/json;charset=utf-8'});
       res.end(body);
     } else {
       res.status(response.statusCode).end();
       console.log('error = ' + response.statusCode);
     }
   });
 });

 app.listen(3000, function () {
   console.log('http://127.0.0.1:3000/translate app listening on port 3000!');
 });