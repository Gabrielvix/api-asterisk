const path = require('path');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
    mode: 'production',
    entry: './dist/**/*.js', // Padrão para corresponder a todos os arquivos JavaScript em todas as subpastas de src
    output: {
        path: path.resolve(__dirname, ''), // Pasta onde o arquivo minificado será gerado
        filename: 'bundle.min.js', // Nome do arquivo minificado
    },
    optimization: {
        minimizer: [
            new TerserPlugin({
                terserOptions: {
                    ecma: 5, // Força o Terser a gerar código para o ECMAScript 5
                    compress: {
                        drop_console: true, // Remove chamadas para console.* functions
                    },
                    output: {
                        comments: false, // Remove todos os comentários
                    },
                },
            }),
        ],
    },
};
