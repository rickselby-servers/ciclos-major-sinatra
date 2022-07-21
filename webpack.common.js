const path = require('path');
const AssetsPlugin = require('assets-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
    entry: {
        app: [
            './js/app.js',
            './sass/app.scss'
        ],
        holder: './js/holder.js'
    },
    output: {
        filename: 'js/[name].js',
        path: path.resolve(__dirname, 'public'),
        publicPath: '/'
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                loader: 'babel-loader'
            },
            {
                test: /\.scss$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    'css-loader',
                    'sass-loader',
                ],
            },
            {
                test: /\.png$/,
                type: 'asset/resource',
                generator: {
                    filename: 'img/[name][ext][query]'
                }
            },
            {
                test: /\.(eot|svg|ttf|woff|woff2)$/,
                type: 'asset/resource',
                generator: {
                    filename: 'fonts/[name][ext][query]'
                }
            },
        ],
    },
    plugins: [
        new AssetsPlugin({
            path: path.resolve(__dirname, 'public'),
            filename: 'manifest.json'
        }),
    ]
};
