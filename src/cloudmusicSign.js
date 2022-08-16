const state = {};

function getTaskDomain() {
    return 'music.163.com';
}

// return a json string of the function list
function getTaskFunctionList() {
    return `
        {
            "signPhone": "手机端签到",
            "signPc": "电脑端签到"
        }
    `;
}

function setTaskPassport(passport) {
    state.passport = passport;
}

function signPhone() {
    const url = 'https://music.163.com/weapi/point/dailyTask';
    const headers = {
        'Cookie': state.passport
    };
    const data={
        'params': 'gXOL4HhNB42ntWdcf5ZqeiDxlz5Jzl%2BZOD57c4c9xqo%3D',
        'encSecKey': 'c8ad95f67079c3f34749858236b3a629da03729536a12ace6a173e44ad5b7184cd13f4d4a40e65320b74d7e3193a8306a9d6a962d89a8736eca9e1ffde1a3f1ada6bed84d957cde517b64b3ee6a0ea8f722c48fb416121f3f616a775327d1d19b2b717149d82ee72fab5171745d20b4c737514751b6513a017db5181a528d0a8'
    };

    const result = requests.post(url, data, headers);
    logger.info(result.code, result.content);

    return true
}

function signPc() {
    const url = 'https://music.163.com/weapi/point/dailyTask';
    const headers = {
        'Cookie': state.passport
    };
    const data={
        'params': 'bd0rBcXJbtb%2F7RYGofKEUZDjSL0kEd5tLrqy1Ns4CO8%3D',
        'encSecKey': 'c8ad95f67079c3f34749858236b3a629da03729536a12ace6a173e44ad5b7184cd13f4d4a40e65320b74d7e3193a8306a9d6a962d89a8736eca9e1ffde1a3f1ada6bed84d957cde517b64b3ee6a0ea8f722c48fb416121f3f616a775327d1d19b2b717149d82ee72fab5171745d20b4c737514751b6513a017db5181a528d0a8'
    };

    const result = requests.post(url, data, headers);
    logger.info(result.code, result.content);

    return true
}