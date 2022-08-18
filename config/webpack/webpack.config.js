'use strict';

const Dotenv = require('dotenv-webpack');
const { webpackConfig, merge } = require('shakapacker');

const customConfig = {
  plugins: [new Dotenv()],
  module: {
    rules: [
      // ...
    ]
  }
};

// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.

module.exports = merge(webpackConfig, customConfig);
