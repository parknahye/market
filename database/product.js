// DynamoDB 데이터베이스 연결 설정
const AWS = require('aws-sdk')
const dynamoClient = new AWS.DynamoDB.DocumentClient()

const PRODUCT = "product"

// 마라톤 전체조회
const getProduct = async () => {
    const params = {
        TableName: PRODUCT
    }

    console.log(params)

    const list = await dynamoClient.scan(params).promise()

    console.log(list);

    return list
}

module.exports = {
    getProduct
}