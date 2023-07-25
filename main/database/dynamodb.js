const AWS = require('aws-sdk')

AWS.config.update({
    region: "ap-northeast-2",
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
  })
  
const productModule = require('./product')
const getProduct = productModule.getProduct
const addProduct = productModule.addProduct
const updateProduct = productModule.updateProduct
const deleteProduct = productModule.deleteProduct

module.exports = {
  getProduct,
  addProduct,
  updateProduct,
  deleteProduct
}