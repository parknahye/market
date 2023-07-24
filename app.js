const express = require('express');
const app = express();
const port = 9000;
const dotenv = require('dotenv');

dotenv.config();

app.use(express.json());

module.exports = {
    app
};


app.get('/', (req, res) => {
    res.send('access key: ' + process.env.AWS_ACCESS_KEY_ID);
});

const productRouter = require('./routes/api/product/index')
app.use('/product', productRouter)


app.listen(port, () => {
    console.log(`Server is listening on port ${port}`);
});