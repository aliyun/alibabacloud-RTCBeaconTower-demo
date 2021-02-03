import Vue from 'vue';
function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}
/**
 * require.context(path,boolean,reg) 
 * path 你要引入文件的目录
 * boolean 是否要查找该目录下的子级目录
 * reg 匹配要引入的文件
 */
const requireComponent = require.context(
    '.', false, /\.vue$/
    //找到components文件夹下以.vue格式的文件。
)
requireComponent.keys().forEach(fileName => {
    const componentConfig = requireComponent(fileName)
    const componnentName = capitalizeFirstLetter(
        fileName.replace(/^\.\//, '').replace(/\.\w+$/, '')
        //因为这里获得的是文件全名 /baseName.vue/ 我们需要去掉头和尾只保留文件名
    )
    Vue.component(componnentName, componentConfig.default || componentConfig)
})