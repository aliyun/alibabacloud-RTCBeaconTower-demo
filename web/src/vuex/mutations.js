// 更改 Vuex 的 store 中的状态的唯一方法是提交 mutation
// this.$store.commit(method, params)


export default {
  //修改公共参数
  hvuex(state, v) {
    var strObj = JSON.stringify(state.data);
    var obj = Object.assign(JSON.parse(strObj), v);
    state.data = obj;
    hsetStore("hvuex",JSON.stringify(state.data));
  }
}

