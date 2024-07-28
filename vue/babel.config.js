// babel.config.js
module.exports = {
  presets: [
    '@babel/preset-env',
    // 如果你使用的是 Vue 2 + JSX，需要添加 @vue/babel-preset-jsx
    // '@vue/babel-preset-jsx'
  ],
  plugins: [
    '@babel/plugin-transform-private-methods',
  ],
};
