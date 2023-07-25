const express = require('express')
const router = express.Router();
router.use(express.json())

const {getProduct, addProduct, updateProduct, deleteProduct} = require('../../../database/dynamodb')

router.get('/', async (req, res) => {
  
    try {
        const product = await getProduct()
        res.json(product)
} catch (error) {
        console.error(error)
        res.status(500).json({err: `Something went wrong`})
}
})

router.post('/add', async (req, res) => {
        try {
                const data = req.body
                console.log(data)
                const newProduct = await addProduct(data)
                res.json(newProduct)

        }catch (error){
                console.error(error)
        }
        
})

router.put('/update/:id', async (req, res) => {
        const { id } = req.params

        console.log(id)
        const data = req.body

        const parsedId = parseInt(id, 10)
        const updateById = await updateProduct(parsedId, data)
        res.json(updateById)
})

router.delete('/:id', async (req, res) => {
        const { id } = req.params

        const parsedId = parseInt(id, 10)
        const deleteById = await deleteProduct(parsedId)
        res.json(deleteById)

})

module.exports = router