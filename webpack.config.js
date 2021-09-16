const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: {
    index: './src/index.js',
    bulma: './src/bulma.js',
    materialize: './src/materialize.js'
  },
  mode: 'development',
  devtool: 'source-map',
	module: {
    rules: [
      {
        test: /\.s[ac]ss$/i,
        use: [
          "style-loader",
          "css-loader",
          "sass-loader"
        ],
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: 'elm-webpack-loader',
          options: {
            pathToElm: 'node_modules/.bin/elm',
            debug: true
          }
        }
      }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Razoyo Internship | Elm Frontend Only',
      chunks : ['index'],
    }),
    new HtmlWebpackPlugin({
      title: 'Razoyo Internship | Elm Frontend Only',
      filename: 'bulma.html',
      chunks : ['bulma'],
    }),
    new HtmlWebpackPlugin({
      template: 'src/materialize.html',
      filename: 'materialize.html',
      chunks : ['materialize'],
    })
  ],
  output: {
    filename: 'main-[name].js',
    path: path.resolve(__dirname, 'dist'),
    clean: true
  },
  devServer: {
    host: '0.0.0.0',
    allowedHosts: 'all',
    static: ['dist'],
    liveReload: true,
    client: {
      logging: 'verbose'
    }
  }
};
