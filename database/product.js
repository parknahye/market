// DynamoDB 데이터베이스 연결 설정
const AWS = require('aws-sdk')
const dynamoClient = new AWS.DynamoDB.DocumentClient()

const PRODUCT = "product"

// 상품조회
const getProduct = async () => {
    const params = {
      TableName: PRODUCT
    };
  
      const list = await dynamoClient.scan(params).promise();

      return list;


  };

module.exports = {
    getProduct
}