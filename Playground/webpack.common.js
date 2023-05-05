const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const MonacoWebpackPlugin = require("monaco-editor-webpack-plugin");
const CopyWebbackPlugin = require("copy-webpack-plugin");

module.exports = {
  entry: {
    index: "./Public/index.js",
    "editor.worker": "monaco-editor/esm/vs/editor/editor.worker.js",
  },
  output: {
    globalObject: "self",
    filename: "[name].[contenthash].js",
    path: path.resolve(__dirname, "Public/dist"),
    publicPath: "/",
    clean: true,
  },
  module: {
    rules: [
      {
        test: /\.scss$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
          },
          {
            loader: "css-loader",
            options: {
              url: false,
              sourceMap: true,
              importLoaders: 2,
            },
          },
          {
            loader: "postcss-loader",
            options: {
              sourceMap: true,
              postcssOptions: {
                plugins: ["autoprefixer"],
              },
            },
          },
          {
            loader: "sass-loader",
            options: {
              sourceMap: true,
            },
          },
        ],
      },
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader"],
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/i,
        type: "asset/resource",
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: "[name].[contenthash].css",
    }),
    new HtmlWebpackPlugin({
      chunks: ["index"],
      filename: "index.leaf",
      template: "./Public/index.html",
    }),
    new MonacoWebpackPlugin({
      filename: "[name].[contenthash].worker.js",
      languages: ["swift"],
    }),
    new CopyWebbackPlugin({
      patterns: [
        // { from: "./Public/images", to: "images" },
        // { from: "./Public/favicons", to: "favicons" },
        // { from: "./Public/apple-touch-icon.png", to: "apple-touch-icon.png" },
        // { from: "./Public/favicon.ico", to: "favicon.ico" },
        { from: "./Public/error.html", to: "error.leaf" },
        { from: "./Public/robots.txt", to: "robots.txt" },
      ],
    }),
  ],
  optimization: {
    splitChunks: {
      cacheGroups: {
        "monaco-editor": {
          test: /[\\/]monaco-editor[\\/]/,
          chunks: "initial",
          name: "monaco-editor",
        },
        xterm: {
          test: /[\\/]xterm[\\/]/,
          chunks: "initial",
          name: "xterm",
        },
      },
    },
  },
};
