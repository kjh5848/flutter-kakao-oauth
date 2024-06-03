import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../../_core/http.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("카카오 로그인"),
      ),
      body: ElevatedButton(
        onPressed: () async {
          kakaologin();
        },
        child: Text("카카오 로그인"),
      ),
    );
  }

  void kakaologin() async {
    try {
      //1. 크리덴셜 로그인 - 토큰 받기
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      //
      print('카카오계정으로 로그인 성공 ${token.accessToken}');

      //2. 토큰을 스프링 서버에 전달하기(스프링 서버한테 나 인증했어!! 라고 알려주는 것)
      final response =  await dio.get("/oauth/callback", queryParameters: {"accessToken" : token.accessToken});
      print("👍👍👍👍👍👍👍👍👍👍");
      response.toString();

      //3. 토큰(스프링서버)의 토큰 응답받기
      final blogAccessToken = response.headers["Authorization"]!.first;
      print("blogAccessToken : ${blogAccessToken}");


      //4. 시큐어 스토리지에 저장
      secureStorage.write(key: "blogAccessToken", value: blogAccessToken);

      //5. static, const 변수, riverpod 상태관리(생략)
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');

    }
  }
}
