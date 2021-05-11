const HtmlWebpackPlugin = require("html-webpack-plugin");

const {
  resolve
} = require("path");
var path = require("path");

module.exports = {
  plugins: [
    new HtmlWebpackPlugin({
      template: "./src/index.html",
      inject: "body",
      chunks: ['index']
    })
  ],

  entry: {
    app: [
      './src/index.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js'
  },

  module: {
    rules: [{
        test: /\.(css|scss)$/,
        loaders: [
          'style-loader',
          'css-loader'
        ],
      },

      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [{
            loader: 'elm-hot-webpack-loader'
          },
          {
            loader: "elm-webpack-loader",
            options: {
              debug: true,
            }
          }
        ]
      },
      {
        exclude: [/elm-stuff/, /node_modules/],
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff',
      },
      {
        exclude: /node_modules/,
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
    ],
    noParse: /\.elm$/,
  },

  devServer: {
    inline: true,
    stats: {
      colors: true
    },
  }
}