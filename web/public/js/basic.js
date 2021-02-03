/*本地存储*/
function setStore(n, v) {
        window.localStorage.setItem(n, v);
}
function getStore(n) {
        return window.localStorage.getItem(n);
}
function hsetStore(n, v) {
        window.sessionStorage.setItem(n, v);
}
function hgetStore(n) {
        return null;
        return window.sessionStorage.getItem(n);
}


Array.prototype.getObjByproprety = function (val, name) {
        var arr = this;
        for (let index = 0; index < arr.length; index++) {
                const element = arr[index];
                if (element[name] == val) {
                   return element;
                }
        }
        return {};
}