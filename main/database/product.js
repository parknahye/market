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

// 상품추가
const addProduct = async (list) => {
  console.log(list)
  const params = {
    TableName: PRODUCT,
    Item: list
  }

  return await dynamoClient.put(params).promise()
}

const updateProduct = async (id, data) => {

  console.log(id, data)
  const params = {
    TableName: PRODUCT,
    Key: {
      id: id
    },
    UpdateExpression: 'SET price = :newprice',
    ExpressionAttributeValues: {
      ':newprice': data.price
    },
    ReturnValues: 'ALL_NEW'
  }

  return await dynamoClient.update(params).promise()
}

const deleteProduct= async (id) => {
  const params = {
      TableName: PRODUCT,
      Key: {
          id: id 
      }
  }

  return await dynamoClient.delete(params).promise()
}


module.exports = {
    getProduct,
    addProduct,
    updateProduct,
    deleteProduct
}