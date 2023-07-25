# market project
---

## 아키텍쳐

![market_project_0 2](https://github.com/parknahye/market/assets/127065825/e24f96dd-706c-4005-86ab-14baa1f7c67d)




>1. 개발자가 새로운 버전을 릴리즈하면 GithubAction을 통하여 자동화 배포가 진행됩니다. 새로운 이미지를 빌드한 후 market_ecr이라는 레포지토리에 푸시한 후 service에 컨테이너를 자동으로 배포합니다.
>2. 사용자는 Route53을 통한 도메인으로 접속하여 서비스를 이용할 수 있습니다.
>3. market_server에 api 요청을 통해 CRUD 작업을 할 수 있습니다. 해당 결과는 DynamoDB에 저장됩니다. market_alb를 통하여 부하를 분산하고 헬스체크를 할 수 있습니다.
>4. 서버 사용량이 많아질 경우 auto scaling을 통하여 테스크는 최대 2개까지 늘어날 수 있습니다.



## 인프라 설명

>1. AutoScaling, ALB, CloudFront, Route53을 활용하여 가용성, 내결함성, 확장성, 보안성 확보
>2. GithubAction 을 통한 CI/CD
>3. NoSQL 인 DynamoDB 를 사용


---

## Install Dependencies

```
npm install express
npm start
```

- express: ^4.18.2
- aws-sdk: ^2.1399.0
