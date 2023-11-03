const initialHeader = document.querySelector('h1');
const name = initialHeader.textContent;

document.body.removeChild(initialHeader);

const fonts = [
    'Arial',
    'Helvetica',
    'Times New Roman',
    'Times',
    'Georgia',
    'Palatino',
    'Verdana',
    'Tahoma',
    'Trebuchet MS',
    'Courier New',
    'Courier',
    'Lucida Sans',
    'Lucida Console',
    'Impact',
    'Book Antiqu',
];

function getRandomItem(list) {
    const randomIndex = Math.floor(Math.random() * list.length);
    return list[randomIndex];
}

function initFancyName(str) {
    const testElement = document.createElement('h1');
    for (let i = 0; i < str.length; i++) {
        const newSpan = document.createElement('span');
        newSpan.textContent = str[i];
        testElement.appendChild(newSpan);
    };
    document.body.appendChild(testElement);
}

function replaceFontsInName() {
    const s = document.querySelector('h1').childNodes;
    for (let i = 0; i < s.length; i++) {
        // s[i].style.color = 'blue';
        s[i].style.fontFamily = getRandomItem(fonts);
    };
}

initFancyName(name);
replaceFontsInName()

setInterval(replaceFontsInName, 100);