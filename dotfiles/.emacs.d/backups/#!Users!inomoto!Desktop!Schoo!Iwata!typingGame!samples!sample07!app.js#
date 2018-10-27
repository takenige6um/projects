var QUESTION = localStorage.QUESTION || 'schoo WEB campus';

var types = [];
function init() {
    document.querySelector('.container').innerHTML = '';

    types = QUESTION.split('').map(function(str) {
        var type = document.createElement('span');
        type.className = 'type';
        type.textContent = str;
        document.querySelector('.container').appendChild(type);
        return type;
    });

    timerEnd();
    document.querySelector('.timer').textContent = '0.000';
}
init();

var timer = null;
var startTime = 0;
function timerStart() {
    startTime = new Date().getTime();
    timer = setInterval(function() {
        var time = (new Date().getTime() - startTime) / 1000;
        document.querySelector('.timer').textContent = time.toFixed(3);
    }, 10);
}
function timerEnd() {
    clearInterval(timer);
    timer = null;
}


document.addEventListener('keydown', function(event) {
    var keyCode = event.keyCode;
    if (keyCode === 13) { // enter key
        init();
        return;
    }

    var key = '';
    if (keyCode === 32) { // space key
        key = ' ';

    } else if (keyCode >= 65 && keyCode <= 90) { // a to z // 修正
        key = String.fromCharCode(keyCode);
        if (event.shiftKey) {
            key = key.toUpperCase();
        } else {
            key = key.toLowerCase();
        }
    }

    if (key) {
        if (timer === null && types.length) { // 修正
            timerStart();
        }

        var next = types[0];
        if (next.textContent === key) {
            next.classList.add('ok');
            types.shift();

            if (types.length === 0) {
                timerEnd();
            }

        } else {
            next.classList.add('ng');
        }
    }
});

document.querySelector('.container').addEventListener('click', function(event) {
    var text = prompt('問題文を入力して下さい');
    if (text) {
        localStorage.QUESTION = QUESTION = text; // 変更
        init();
    }
});
