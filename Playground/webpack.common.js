const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const MonacoWebpackPlugin = require("monaco-editor-webpack-plugin");
const CopyWebbackPlugin = require("copy-webpack-plugin");

module.exports = {
  entry: {
    index: "./frontend/index.js",
    "editor.worker": "monaco-editor/esm/vs/editor/editor.worker.js",
  },
  output: {
    globalObject: "self",
    filename: "[name].[contenthash].js",
    path: path.resolve(__dirname, "dist"),
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
      {
        test: "/.worker.js$/",
        loader: "worker-loader",
        options: {
          filename: "[name].[contenthash].worker.js",
        },
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: "[name].[contenthash].css",
    }),
    new HtmlWebpackPlugin({
      chunks: ["index"],
      filename: "index.html",
      template: "./frontend/index.html",
    }),
    new MonacoWebpackPlugin({
      filename: "[name].[contenthash].worker.js",
      languages: ["swift"],
    }),
    new CopyWebbackPlugin({
      patterns: [
        { from: "./frontend/images/*.*", to: "images/[name][ext]" },
        { from: "./frontend/favicons/*.*", to: "[name][ext]" },
        { from: "./frontend/error.html", to: "error.html" },
        { from: "./frontend/robots.txt", to: "robots.txt" },
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
