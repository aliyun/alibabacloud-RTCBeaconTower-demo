const fs = require('fs')
module.exports = {
    publicPath: './',
    //   lintOnSave：{ type:Boolean default:true } 问你是否使用eslint
    lintOnSave: true,
    // productionSourceMap：{ type:Bollean,default:true } 生产源映射
    // 如果您不需要生产时的源映射，那么将此设置为false可以加速生产构建
    productionSourceMap: false,
    // devServer:{type:Object} 3个属性host,port,https
    // 它支持webPack-dev-server的所有选项
 
    devServer: {
        port: 888, // 端口号
        host: '0.0.0.0',
        hot:true,
        https: true, // https:{type:Boolean}
        open: true,//配置自动启动浏览器
        proxy: {
          '/interactive-live-class': {
            target: 'https://alivc-demo.aliyuncs.com',
            ws: true,
            changeOrigin: true
          }
        }
    },
    css: {
    loaderOptions: {
      sass: {
        data: fs.readFileSync('src/assets/scss/base.scss', 'utf-8')
      }
    }
  }
}