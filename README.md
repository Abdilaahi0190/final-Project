# ShaqoRaadi - Platform-ka Shaqo Raadinta

Kani waa mashruuc gaba-gabo ah (Final Project) oo loo dhisay sidii loogu fududeyn lahaa dadka raadinaya shaqooyinka iyo shirkadaha shaqaaleysiinta.

## 1. Tiknoolajiyadda la Adeegsaday
- **Frontend**: Flutter (Framework)
- **Backend**: Node.js & Express
- **Database**: MongoDB
- **State Management**: GetX (Wixii ku saabsan maaraynta xogta)

## 2. Naqshadda App-ka (Architecture)
Mashruucan waxaa loo dhisay qaabka **MVVM (Model-View-ViewModel)** isagoo isticmaalaya GetX:

- **Models**: Waxay qeexayaan qaabka xogta (sida Job iyo User).
- **Views (Screens)**: Waa muuqaalka app-ka ee uu isticmaalahu arkayo.
- **Controllers**: Waxay xambaarsan yihiin dhammaan caqli-galnimada (Logic) iyo xiriirka backend-ka.
- **Services**: Waxay maareeyaan isgaarsiinta API-yada.

**Sababta loo doortay GetX**:
Waxaan u dooranay GetX sababtoo ah waxay siisaa app-ka wax-qabad degdeg ah, waxayna si fudud u kala saartaa muuqaalka (UI) iyo caqliga (Logic), taas oo ka dhigaysa koodhka mid nadiif ah oo si fudud loo habayn karo.

## 3. Habka Dejinta (Installation)

### Backend
1. Tag galka `backend`: `cd backend`
2. Ku shub dependencies-ka: `npm install`
3. Bilow server-ka: `npm start`

### Frontend
1. Hubi in Flutter uu ku rakiban yahay.
2. Ku shub packages-ka: `flutter pub get`
3. Ku kici app-ka simulator ama qalab dhab ah: `flutter run`

## 4. Requirement-yada Rubric-ka
- [x] **GitHub & Version Control**: Koodhka wuxuu ku jiraa GitHub oo leh commit-yo macno leh.
- [x] **State Management**: Waxaan isticmaalnay GetX si hufan.
- [x] **Backend Integration**: Waxay ku xiran tahay Node.js dhab ah.
- [x] **Documentation**: Dhammaan koodhka waxaa lagu sharaxay af-Soomaali.
- [x] **UI/UX**: Naqshad fudud, nadiif ah, oo labo midab kaliya leh (Purple & Blue).
- [x] **App Icon & Name**: App-ka magaciisu waa ShaqoRaadi, calaamadiisuna waa mid u gaar ah.

---
Mashruucan waxaa diyaariyay kooxda ka qalin-jebineysa kuliyadda Tiknoolajiyadda.
