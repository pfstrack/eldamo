document.addEventListener('DOMContentLoaded', () => {

    const savedMode = localStorage.getItem('darkMode');

    if (savedMode === 'true') {
        document.body.classList.add('dark-mode');
        updateToggleButton(true);
    } else {
        updateToggleButton(false);
    }


    let btn = document.getElementById('darkModeBtn');
    if (!btn) {
        btn = document.createElement('button');
        btn = document.createElement('button');
        btn.id = 'darkModeBtn';
        btn.style.position = 'absolute';
        btn.style.top = '0.9rem';
        btn.style.right = '1rem';
        btn.style.zIndex = '9999';
        btn.style.background = 'none';
        btn.style.border = 'none';
        btn.style.padding = '0';
        btn.style.cursor = 'pointer';
        btn.style.color = 'inherit';
        btn.style.display = 'flex';
        btn.style.alignItems = 'center';
        btn.style.justifyContent = 'center';
        btn.style.width = '32px';
        btn.style.height = '32px';
        document.body.appendChild(btn);
    }

    updateToggleButton(document.body.classList.contains('dark-mode'));

    btn.addEventListener('click', toggleDarkMode);
});

function toggleDarkMode() {
    const isDark = document.body.classList.toggle('dark-mode');
    localStorage.setItem('darkMode', isDark);
    updateToggleButton(isDark);
}

function updateToggleButton(isDark) {
    const btn = document.getElementById('darkModeBtn');
    if (btn) {
        btn.innerHTML = isDark
            ? `<svg xmlns="http://www.w3.org/2000/svg" height="24" width="24" viewBox="0 0 24 24">
                <path fill="currentColor" d="M12,9c1.65,0,3,1.35,3,3s-1.35,3-3,3s-3-1.35-3-3S10.35,9,12,9 
                M12,7c-2.76,0-5,2.24-5,5s2.24,5,5,5s5-2.24,5-5 S14.76,7,12,7L12,7z 
                M2,13l2,0c0.55,0,1-0.45,1-1s-0.45-1-1-1l-2,0
                c-0.55,0-1,0.45-1,1S1.45,13,2,13z 
                M20,13l2,0c0.55,0,1-0.45,1-1 
                s-0.45-1-1-1l-2,0c-0.55,0-1,0.45-1,1S19.45,13,20,13z 
                M11,2v2c0,0.55,0.45,1,1,1s1-0.45,1-1V2
                c0-0.55-0.45-1-1-1S11,1.45,11,2z 
                M11,20v2c0,0.55,0.45,1,1,1s1-0.45,1-1v-2
                c0-0.55-0.45-1-1-1C11.45,19,11,19.45,11,20z 
                M5.99,4.58c-0.39-0.39-1.03-0.39-1.41,0 
                c-0.39,0.39-0.39,1.03,0,1.41l1.06,1.06
                c0.39,0.39,1.03,0.39,1.41,0s0.39-1.03,0-1.41L5.99,4.58z 
                M18.36,16.95c-0.39-0.39-1.03-0.39-1.41,0
                c-0.39,0.39-0.39,1.03,0,1.41l1.06,1.06
                c0.39,0.39,1.03,0.39,1.41,0c0.39-0.39,0.39-1.03,0-1.41L18.36,16.95z 
                M19.42,5.99c0.39-0.39,0.39-1.03,0-1.41
                c-0.39-0.39-1.03-0.39-1.41,0l-1.06,1.06
                c-0.39,0.39-0.39,1.03,0,1.41s1.03,0.39,1.41,0L19.42,5.99z 
                M7.05,18.36c0.39-0.39,0.39-1.03,0-1.41
                c-0.39-0.39-1.03-0.39-1.41,0l-1.06,1.06
                c-0.39,0.39-0.39,1.03,0,1.41s1.03,0.39,1.41,0L7.05,18.36z"/>
              </svg>`
            : `<svg xmlns="http://www.w3.org/2000/svg" height="24" width="24" viewBox="0 0 24 24">
                <path fill="currentColor" d="M9.37,5.51C9.19,6.15,9.1,6.82,9.1,7.5
                c0,4.08,3.32,7.4,7.4,7.4c0.68,0,1.35-0.09,1.99-0.27
                C17.45,17.19,14.93,19,12,19c-3.86,0-7-3.14-7-7
                C5,9.07,6.81,6.55,9.37,5.51z M12,3c-4.97,0-9,4.03-9,9
                s4.03,9,9,9s9-4.03,9-9c0-0.46-0.04-0.92-0.1-1.36
                c-0.98,1.37-2.58,2.26-4.4,2.26c-2.98,0-5.4-2.42-5.4-5.4
                c0-1.81,0.89-3.42,2.26-4.4C12.92,3.04,12.46,3,12,3L12,3z"/>
              </svg>`;
    }
}

