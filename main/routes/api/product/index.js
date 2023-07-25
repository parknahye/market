const express = require('express')
const router = express.Router();
router.use(express.json())

const {getProduct} = require('../../../database/dynamodb')

router.get('/', async (req, res) => {
    try {
        const product = await getProduct()
        res.json(product)
} catch (error) {
        console.error(error)
        res.status(500).json({err: `Something went wrong`})
}
})


module.exports = router