const {merge} = require('webpack-merge');
const common = require('./webpack.common.js');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = merge(common, {
    mode: 'production',
    output: {
        filename: 'js/[name]-[contenthash].js',
    },
    plugins: [
        new MiniCssExtractPlugin({
            filename: "css/[name]-[contenthash].css",
        }),
    ],
});
