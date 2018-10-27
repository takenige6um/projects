
((digest . "d41d8cd98f00b204e9800998ecf8427e") (undo-list nil ("(function() {
  'use strict';

  var canvas = document.getElementById('stage');
  var context;
  var image;
  var IMAGE_URL = '15puzzle.png';
  // tiles[0][0] = 0;
  // tiles[0][1] = 1;
  // tiles[0][2] = 2;
  // tiles[0][3] = 3;
  // tiles[1][0] = 4;
  // tiles[1][1] = 5;
  // tiles[1][2] = 6;
  // tiles[1][3] = 7;
  // tiles[2][0] = 8;
  // tiles[2][1] = 9;
  // tiles[2][2] = 10;
  // tiles[2][3] = 11;
  // ...
  var tiles = [];
  var ROW_COUNT = 4;
  var COL_COUNT = 4;
  var PIC_WIDTH = 280;
  var PIC_HEIGHT = 280;
  var TILE_WIDTH = PIC_WIDTH / COL_COUNT;
  var TILE_HEIGHT = PIC_HEIGHT / ROW_COUNT;
  var UDLR = [
    [ 0, -1],
    [ 0,  1],
    [-1,  0],
    [ 1,  0]
  ];
  var moveCount = 2;

  function initTiles() {
    var row, col;
    for (row = 0; row < ROW_COUNT; row++) {
      tiles[row] = [];
      for (col = 0; col < COL_COUNT; col++) {
        tiles[row][col] = row * COL_COUNT + col;
      }
    }
    tiles[ROW_COUNT - 1][COL_COUNT - 1] = -1;
    // console.log(tiles);
  }

  function drawPuzzle() {
    // context.drawImage(image, 0, 0);
    var row, col;
    var sx, sy;      // 元画像は source
    var dx, dy;      // 配置先は destination

    for (row = 0; row < ROW_COUNT; row++) {
      for (col = 0; col < COL_COUNT; col++) {
        dx = col * TILE_WIDTH;
        dy = row * TILE_HEIGHT;
        if (tiles[row][col] === -1) {
          context.fillStyle = '#eeeeee';
          context.fillRect(dx, dy, TILE_WIDTH, TILE_HEIGHT);
        } else {
        sx = (tiles[row][col] % COL_COUNT) * TILE_WIDTH;
        sy = Math.floor((tiles[row][col] / ROW_COUNT)) * TILE_HEIGHT;
        context.drawImage(image, sx, sy, TILE_WIDTH, TILE_HEIGHT, dx, dy, TILE_WIDTH, TILE_HEIGHT);

        }
      }
    }
  }

  function checkResult() {
    var row, col;
    for (row = 0; row < ROW_COUNT; row++) {
      for (col = 0; col < COL_COUNT; col++){
        if (row === ROW_COUNT - 1 && col === COL_COUNT - 1) {
          return true;
        }
        if (tiles[row][col] !== row * COL_COUNT + col) {
          return false;
        }
      }
    }
  }

  function moveBlank(count) {
    var blankRow, blankCol;
    var targetPosition;
    var targetRow, targetCol;

    blankRow = ROW_COUNT - 1;
    blankCol = COL_COUNT - 1;

    while(true) {
      targetPosition = Math.floor(Math.random() * UDLR.length);
      targetRow = blankRow + UDLR[targetPosition][1];
      targetCol = blankCol + UDLR[targetPosition][0];
      if (targetRow < 0 || targetRow >= ROW_COUNT) {
        continue;
      }
      if (targetCol < 0 || targetCol >= COL_COUNT) {
        continue;
      }
      tiles[blankRow][blankCol] = tiles[targetRow][targetCol];
      tiles[targetRow][targetCol] = -1;
      blankRow = targetRow;
      blankCol = targetCol;
      if (!--count) {
        break;
      }
    }
  }

  if (!canvas.getContext) {
    alert('Canvas not supported ...');
    return;
  }
  context = canvas.getContext('2d');

  image = document.createElement('img');
  image.src = IMAGE_URL;
  image.addEventListener('load', function() {
    initTiles();
    moveBlank(moveCount);
    drawPuzzle();
  });

  canvas.addEventListener('click', function(e) {
    var x, y;
    var rect;
    var row, col;
    var i;
    var targetRow, targetCol;
    
    rect = e.target.getBoundingClientRect();
    x = e.clientX - rect.left;
    y = e.clientY - rect.top;
    row = Math.floor(y / TILE_HEIGHT);
    col = Math.floor(x / TILE_WIDTH);
    if (tiles[row][col] === -1) {
      return;
    }
    // console.log(row, col);

    for (i = 0; i < UDLR.length; i++) {
      targetRow = row + UDLR[i][1];
      targetCol = col + UDLR[i][0];
      if (targetRow < 0 || targetRow >= ROW_COUNT) {
        continue;
      }
      if (targetCol < 0 || targetCol >= COL_COUNT) {
        continue;
      }
      if (tiles[targetRow][targetCol] === -1) {
        tiles[targetRow][targetCol] = tiles[row][col];
        tiles[row][col] = -1;
        drawPuzzle();
        if (checkResult()) {
          alert('Game Clear');
        }
        break;
      }
    }
  });
})();
" . 1) ((marker . 1) . -2633) ((marker . 1) . -4054) ((marker . 1) . -500) ((marker . 1) . -1424) ((marker . 1) . -1713) ((marker* . 1) . 540) ((marker . 1) . -1475) ((marker . 1) . -3487) ((marker . 1) . -639) ((marker . 1) . -3701) ((marker . 1) . -3709) ((marker . 1) . -2381) ((marker . 1) . -3630) ((marker . 1) . -2435) ((marker . 1) . -2656) ((marker . 1) . -142) ((marker . 1) . -704) ((marker . 1) . -2060) ((marker . 1) . -2070) ((marker . 1) . -2245) ((marker . 735) . -2070) ((marker . 1) . -1087) ((marker*) . 4054) ((marker) . -1) ((marker*) . 5) ((marker) . -4050) ((marker . 1) . -252) ((marker . 1) . -4054) ((marker) . -4054) (t 23213 53335 967319 99000) nil (1152 . 1153) nil (1152 . 1163) nil (1148 . 1152) ("配置先は" . -1148) ((marker . 735) . -4) (1148 . 1152) ("配置先h" . -1148) ((marker . 735) . -4) (1148 . 1152) ("配置先" . -1148) ((marker . 735) . -3) (1148 . 1151) ("配置さk" . -1148) ((marker . 735) . -4) (1148 . 1152) ("配置さ" . -1148) ((marker . 735) . -3) (1148 . 1151) ("配置s" . -1148) ((marker . 735) . -3) (1148 . 1151) ("配置" . -1148) ((marker . 735) . -2) (1148 . 1150) ("はいt" . -1148) ((marker . 735) . -3) (1148 . 1151) ("はい" . -1148) ((marker . 735) . -2) (1148 . 1150) ("は" . -1148) ((marker . 735) . -1) (1148 . 1149) ("h" . -1148) ((marker . 735) . -1) (1148 . 1149) nil (1144 . 1148) nil (1139 . 1144) nil (1121 . 1123) nil (1112 . 1121) ("元画像は" . -1112) ((marker . 735) . -4) 1116 nil (1112 . 1116) ("元画像h" . -1112) ((marker . 735) . -4) (1112 . 1116) ("元画像" . -1112) ((marker . 735) . -3) (1112 . 1115) ("元がぞ" . -1112) ((marker . 735) . -3) (1112 . 1115) ("元がz" . -1112) ((marker . 735) . -3) (1112 . 1115) ("元が" . -1112) ((marker . 735) . -2) (1112 . 1114) ("元g" . -1112) ((marker . 735) . -2) (1112 . 1114) ("元" . -1112) ((marker . 735) . -1) (1112 . 1113) ("もt" . -1112) ((marker . 735) . -2) (1112 . 1114) ("も" . -1112) ((marker . 735) . -1) (1112 . 1113) ("m" . -1112) ((marker . 735) . -1) (1112 . 1113) nil (1103 . 1112) nil (400 . 401) nil ("0" . -400) ((marker . 735) . -1) 401 nil (377 . 378) nil ("0" . -377) ((marker . 735) . -1) 378 nil (355 . 356) nil ("0" . -355) ((marker . 735) . -1) 356 nil (397 . 398) nil ("1" . -397) ((marker . 735) . -1) 398 nil (374 . 375) nil ("1" . -374) ((marker . 735) . -1) 375 nil (352 . 353) nil ("1" . -352) ((marker . 735) . -1) 353 nil (330 . 331) nil ("1" . -330) ((marker . 735) . -1) 331 nil (311 . 312) nil ("0" . -311) ((marker . 735) . -1) 312 nil (289 . 290) nil ("0" . -289) ((marker . 735) . -1) 290 nil (267 . 268) nil ("0" . -267) ((marker . 735) . -1) 268 nil (405 . 407) nil ("4" . -405) ((marker . 735) . -1) 406 nil (382 . 384) nil ("0" . -382) ((marker . 735) . -1) 383 nil (382 . 383) nil ("4" . -382) ((marker . 735) . -1) 383 nil (360 . 361) nil ("4" . -360) ((marker . 735) . -1) 361 nil (338 . 339) nil ("4" . -338) ((marker . 735) . -1) 339 nil (316 . 317) nil ("4" . -316) ((marker . 735) . -1) 317 nil (294 . 295) nil ("4" . -294) ((marker . 735) . -1) 295 nil (272 . 273) nil ("6" . -272) ((marker . 735) . -1) 273 nil (272 . 273) nil ("4" . -272) ((marker . 735) . -1) 273 nil (nil rear-nonsticky nil 274 . 275) (253 . 275) 250 nil (nil rear-nonsticky nil 274 . 275) (253 . 275) 250 nil (nil rear-nonsticky nil 274 . 275) (253 . 275) 250 nil (nil rear-nonsticky nil 274 . 275) (253 . 275) 250 nil (nil rear-nonsticky nil 274 . 275) (253 . 275) 250 nil (nil rear-nonsticky nil 274 . 275) (253 . 275) 250 nil (nil rear-nonsticky nil 274 . 275) (253 . 275) 250 (t 23207 40078 127310 544000) nil (548 . 549) nil ("3" . -548) ((marker) . -1) ("2" . -549) ((marker) . -1) 550 (t 23207 38939 412084 666000) nil (298 . 299) nil ("1" . -298) ((marker) . -1) ("2" . -299) ((marker) . -1) 300 nil (320 . 321) nil ("1" . -320) ((marker) . -1) ("2" . -321) ((marker) . -1) 322 nil (550 . 552) nil ("1" . -550) ((marker) . -1) ("0" . -551) ((marker) . -1) ("2" . -552) ((marker) . -1) ("4" . -553) ((marker) . -1) 554 (t 23207 38846 351417 222000) nil (550 . 554) nil ("3" . -550) ((marker) . -1) ("2" . -551) ((marker) . -1) 552 nil (320 . 322) nil ("4" . -320) ((marker) . -1) 321 nil (298 . 300) nil ("4" . -298) ((marker) . -1) 299 (t 23207 38675 785287 428000) nil (927 . 928) (t 23207 38252 654794 854000) nil ("
" . 3721) nil ("        moveBlank(moveCount);" . 3721) nil ("
" . 3721) nil ("        initTiles();" . 3721) nil (3044 . 3049) (t 23207 37971 957778 353000) nil (2882 . 2883) nil (2872 . 2881) ("move" . -2872) ((marker) . -4) 2876 nil (2872 . 2876) nil (2871 . 2873) nil (2862 . 2871) ("move" . -2862) ((marker) . -4) 2866 nil (2862 . 2866) nil (2857 . 2862) (t 23207 37767 567776 969000) nil (2494 . 2495) (t 23207 37546 537883 661000) nil (1786 . 1787) nil (1377 . 1378) nil (1375 . 1377) nil ("C" . -1375) ((marker) . -1) ("O" . -1376) ((marker) . -1) ("L" . -1377) ((marker) . -1) 1378 (t 23207 37282 775179 278000) nil (1256 . 1257) (t 23207 36873 169205 721000) nil (548 . 549) (t 23207 36768 164085 919000) nil ("  " . -2601) ((marker) . -2) (2603 . 2604) nil (2598 . 2603) (t 23207 36346 190517 441000) nil (2124 . 2130) ("    " . 2124) (2060 . 2066) ("    " . 2060) 2595 nil ("  " . -2593) ((marker) . -2) (2595 . 2596) nil (2589 . 2595) (2581 . 2587) ("  " . 2581) (2584 . 2585) nil (2574 . 2580) nil (2565 . 2574) nil (2564 . 2565) nil (2563 . 2564) nil (2562 . 2563) nil (2557 . 2562) nil (2554 . 2557) nil (2553 . 2554) nil (2550 . 2553) nil (2543 . 2550) nil (2542 . 2543) nil (2533 . 2542) ("ta" . -2533) ((marker) . -2) 2535 nil (2530 . 2535) nil (2522 . 2530) ("bl" . -2522) ((marker) . -2) 2524 nil (2522 . 2524) nil (2515 . 2522) nil (2514 . 2515) nil (2505 . 2514) ("tar" . -2505) ((marker) . -3) 2508 nil (2502 . 2508) nil (2494 . 2502) ("bla" . -2494) ((marker) . -3) 2497 nil (2494 . 2497) nil (" " . -2488) ((marker) . -1) (" " . -2489) ((marker) . -1) (" " . -2490) ((marker) . -1) (" " . -2491) ((marker) . -1) (" " . -2492) ((marker) . -1) (" " . -2493) ((marker) . -1) 2494 nil (2488 . 2494) nil ("
" . 2488) nil ("        tiles[row][col] = -1;" . 2488) nil ("
" . 2488) nil ("        tiles[targetRow][targetCol] = tiles[row][col];" . 2488) nil ("=" . -2484) ((marker) . -1) ("=" . -2485) ((marker) . -1) 2486 nil (")" . -2489) ((marker) . -1) ((marker*) . 1) ((marker) . -1) (" " . -2490) ((marker) . -1) ("{" . -2491) ((marker) . -1) 2492 nil (2447 . 2448) nil (2437 . 2446) ("ta" . -2437) ((marker) . -2) 2439 nil (2437 . 2439) nil (2436 . 2438) nil (2426 . 2435) ("targetR" . -2426) ((marker) . -7) 2433 nil (2432 . 2433) nil (2426 . 2432) ("tar" . -2426) ((marker) . -3) 2429 nil (2426 . 2429) nil (2425 . 2427) nil (2420 . 2425) ("ti" . -2420) ((marker) . -2) 2422 nil (2419 . 2422) nil ("=" . -2419) ((marker) . -1) ("=" . -2420) ((marker) . -1) (" " . -2421) ((marker) . -1) ("-" . -2422) ((marker) . -1) ("1" . -2423) ((marker) . -1) (")" . -2424) ((marker) . -1) ((marker*) . 1) ((marker) . -1) (" " . -2425) ((marker) . -1) ("{" . -2426) ((marker) . -1) 2427 nil (2408 . 2413) nil ("t" . -2408) ((marker) . -1) ("a" . -2409) ((marker) . -1) ("r" . -2410) ((marker) . -1) ("g" . -2411) ((marker) . -1) ("e" . -2412) ((marker) . -1) ("t" . -2413) ((marker) . -1) 2414 nil (2398 . 2403) nil ("t" . -2398) ((marker) . -1) ("a" . -2399) ((marker) . -1) ("r" . -2400) ((marker) . -1) ("g" . -2401) ((marker) . -1) ("e" . -2402) ((marker) . -1) ("t" . -2403) ((marker) . -1) 2404 nil (2430 . 2474) 2392 nil ("i" . -2392) ((marker) . -1) ("f" . -2393) ((marker) . -1) (" " . -2394) ((marker) . -1) ("(" . -2395) ((marker) . -1) 2396 nil (2234 . 2236) nil ("i" . -2234) ((marker) . -1) ("f" . -2235) ((marker) . -1) 2236 nil (2228 . 2519) nil (2228 . 2234) (2174 . 2180) ("    " . 2174) (2225 . 2226) nil ("}" . -2059) ((marker) . -1) ((marker*) . 1) ((marker) . -1) 2060 nil (2058 . 2060) nil (2057 . 2058) nil (2052 . 2056) nil (2051 . 2053) nil (2047 . 2051) nil (2046 . 2047) nil (2042 . 2046) ("    " . 2041) (2041 . 2045) (2041 . 2042) nil (2204 . 2205) nil ("1" . -2204) ((marker) . -1) 2205 nil (2172 . 2180) ("blankC" . -2172) ((marker) . -6) 2178 nil (2177 . 2178) nil ("R" . -2177) ((marker) . -1) ("o" . -2178) ((marker) . -1) ("w" . -2179) ((marker) . -1) 2180 nil (2166 . 2169) nil ("R" . -2166) ((marker) . -1) ("o" . -2167) ((marker) . -1) ("w" . -2168) ((marker) . -1) (apply yas--snippet-revive 1870 2211 [cl-struct-yas--snippet nil ([cl-struct-yas--field 1 1878 1888 nil nil nil t [cl-struct-yas--field 2 1889 1894 nil nil nil t [cl-struct-yas--field 3 1902 2155 nil nil nil t [cl-struct-yas--exit 2211 nil]]]] [cl-struct-yas--field 2 1889 1894 nil nil nil t [cl-struct-yas--field 3 1902 2155 nil nil nil t [cl-struct-yas--exit 2211 nil]]] [cl-struct-yas--field 3 1902 2155 nil nil nil t [cl-struct-yas--exit 2211 nil]]) [cl-struct-yas--exit 2211 nil] 39 nil [cl-struct-yas--field 3 1902 2155 nil nil nil t [cl-struct-yas--exit 2211 nil]] nil nil]) nil (2156 . 2208) 2155 nil (2154 . 2155) nil (2152 . 2153) nil (2151 . 2153) nil (2136 . 2150) ("target" . -2136) ((marker) . -6) 2142 nil (2136 . 2142) nil (2135 . 2137) nil (2131 . 2135) nil (2128 . 2131) nil (2120 . 2128) ("blank" . -2120) ((marker) . -5) 2125 nil (2117 . 2125) nil (2108 . 2117) ("targetR" . -2108) ((marker) . -7) 2115 nil (2114 . 2115) nil (2111 . 2114) nil (2108 . 2111) nil (2103 . 2108) nil (2102 . 2103) nil (2098 . 2101) nil (2094 . 2098) nil (2090 . 2094) ("UD" . -2090) ((marker) . -2) 2092 nil (2090 . 2092) nil (2087 . 2090) nil (2085 . 2087) nil (2078 . 2085) nil ("," . -2078) ((marker) . -1) 2079 nil (2074 . 2079) nil (2073 . 2075) nil (2063 . 2073) nil (2060 . 2063) nil (2046 . 2060) ("targetP" . -2046) ((marker) . -7) 2053 nil (2052 . 2053) nil (2046 . 2052) ("tar" . -2046) ((marker) . -3) 2049 nil (2046 . 2049) nil (2042 . 2046) ("    " . 2041) (2041 . 2045) (2041 . 2042) ("    " . 2041) ((marker) . -4) 2045 nil (2040 . 2045) nil (2035 . 2040) nil (2026 . 2035) ("CO" . -2026) ((marker) . -2) 2028 nil (2023 . 2028) nil (2015 . 2023) ("blank" . -2015) ((marker) . -5) 2020 nil (2015 . 2020) nil (2010 . 2015) nil (2009 . 2010) nil (2005 . 2009) nil (1996 . 2005) ("RO" . -1996) ((marker) . -2) 1998 nil (1993 . 1998) nil (1985 . 1993) ("blankR" . -1985) ((marker) . -6) 1991 nil (1990 . 1991) nil ("C" . -1990) ((marker) . -1) ("o" . -1991) ((marker) . -1) ("l" . -1992) ((marker) . -1) 1993 nil (1985 . 1993) ("blank" . -1985) ((marker) . -5) 1990 nil (1985 . 1990) nil (1981 . 1985) ("    " . 1980) (1980 . 1984) (1980 . 1981) ("    " . 1980) ((marker) . -4) 1984 nil (1979 . 1984) nil (1975 . 1979) nil (1969 . 1975) ("tar" . -1969) ((marker) . -3) 1972 nil (1969 . 1972) nil (1967 . 1969) nil (1958 . 1967) ("targetR" . -1958) ((marker) . -7) 1965 nil (1964 . 1965) nil (1958 . 1964) ("tar" . -1958) ((marker) . -3) 1961 nil (1957 . 1961) nil ("t" . -1957) ((marker) . -1) ("a" . -1958) ((marker) . -1) ("r" . -1959) ((marker) . -1) 1960 nil (1954 . 1960) nil (1949 . 1954) nil (1944 . 1949) nil (1935 . 1944) nil (1930 . 1935) nil (1925 . 1930) nil (1921 . 1925) nil (1913 . 1921) nil (1912 . 1913) nil ("p" . -1912) ((marker) . -1) ("o" . -1913) ((marker) . -1) ("w" . -1914) ((marker) . -1) 1915 nil (1908 . 1915) nil (1902 . 1908) nil (1889 . 1894) nil (1881 . 1888) nil (1878 . 1881) nil (apply yas--take-care-of-redo [cl-struct-yas--snippet nil ([cl-struct-yas--field 1 1878 1888 nil nil nil t [cl-struct-yas--field 2 1889 1894 nil nil nil t [cl-struct-yas--field 3 1902 2155 nil nil nil t [cl-struct-yas--exit 2211 nil]]]] [cl-struct-yas--field 2 1889 1894 nil nil nil t [cl-struct-yas--field 3 1902 2155 nil nil nil t [cl-struct-yas--exit 2211 nil]]] [cl-struct-yas--field 3 1902 2155 nil nil nil t [cl-struct-yas--exit 2211 nil]]) [cl-struct-yas--exit 2211 nil] 39 nil [cl-struct-yas--field 3 1902 2155 nil nil nil t [cl-struct-yas--exit 2211 nil]] nil nil]) (1888 . 1890) (1883 . 1887) ("  " . 1883) (1870 . 1887) ("f" . 1870) ((marker) . -1) 1871 nil (1870 . 1871) nil (1868 . 1870) ("  " . 1867) (1867 . 1869) (1867 . 1868) ("  " . 1867) ((marker) . -2) 1869 nil (1866 . 1869) nil (545 . 550) nil (536 . 545) ("moveC" . -536) ((marker) . -5) 541 nil (532 . 541) nil (529 . 532) nil (2978 . 2979) nil (2968 . 2977) nil (2967 . 2969) nil (2964 . 2967) nil (2958 . 2964) nil (2949 . 2958) nil (2948 . 2949) nil (2946 . 2948) nil (2944 . 2946) nil ("s" . -2944) ((marker) . -1) 2945 nil (2941 . 2945) nil (2937 . 2941) nil (2928 . 2937) (apply yas--snippet-revive 1511 1845 [cl-struct-yas--snippet nil ([cl-struct-yas--field 1 1519 1531 nil nil nil t [cl-struct-yas--field 2 1532 1532 nil nil nil nil [cl-struct-yas--field 3 1540 1841 nil nil nil t [cl-struct-yas--exit 1845 nil]]]] [cl-struct-yas--field 2 1532 1532 nil nil nil nil [cl-struct-yas--field 3 1540 1841 nil nil nil t [cl-struct-yas--exit 1845 nil]]] [cl-struct-yas--field 3 1540 1841 nil nil nil t [cl-struct-yas--exit 1845 nil]]) [cl-struct-yas--exit 1845 nil] 38 nil [cl-struct-yas--field 3 1540 1841 nil nil nil t [cl-struct-yas--exit 1845 nil]] nil nil]) nil (1811 . 1817) nil (1804 . 1811) nil (1794 . 1804) (1795 . 1803) ("          " . 1794) (1794 . 1804) (1794 . 1795) ("        " . 1794) (1793 . 1802) nil (1792 . 1794) nil (1791 . 1792) nil (1784 . 1790) nil (1775 . 1784) ("CO" . -1775) ((marker) . -2) 1777 nil (1770 . 1777) nil (1764 . 1770) nil (1761 . 1763) nil (1760 . 1762) nil (1756 . 1759) nil (1755 . 1757) nil (1750 . 1755) nil (1749 . 1751) nil (1746 . 1749) nil (1737 . 1746) nil (1721 . 1727) nil (1715 . 1721) nil (1705 . 1715) (1706 . 1714) ("          " . 1705) (1705 . 1715) (1705 . 1706) ("        " . 1705) (1704 . 1713) nil (1703 . 1705) nil (1702 . 1703) nil (1697 . 1701) nil (1688 . 1697) ("CO" . -1688) ((marker) . -2) 1690 nil (1683 . 1690) nil (1680 . 1683) nil ("s" . -1680) ((marker) . -1) 1681 nil (1677 . 1681) nil (1672 . 1677) nil (1663 . 1672) ("RO" . -1663) ((marker) . -2) 1665 nil (1664 . 1665) nil ("O" . -1664) ((marker) . -1) ("M" . -1665) ((marker) . -1) 1666 nil ("
" . -1666) ((marker) . -1) ("
" . -1667) ((marker) . -1) 1668 nil (1666 . 1668) nil (1665 . 1666) nil (1662 . 1665) nil (1655 . 1662) nil (1654 . 1656) nil (1651 . 1654) nil (1643 . 1651) (1644 . 1650) ("        " . 1643) (1643 . 1651) (1643 . 1644) ("      " . 1643) (1642 . 1649) nil (1641 . 1643) nil (1637 . 1640) nil (1633 . 1637) nil (1624 . 1633) ("CO" . -1624) ((marker) . -2) 1626 nil (1618 . 1626) nil (1612 . 1618) nil (1609 . 1612) nil (1608 . 1610) nil (1604 . 1608) nil (1598 . 1604) (1599 . 1603) ("      " . 1598) (1598 . 1604) (1598 . 1599) ("    " . 1598) (1597 . 1602) nil ("M" . -1597) ((marker) . -1) 1598 nil (1597 . 1598) nil ("0" . -1597) ((marker) . -1) 1598 nil (1597 . 1598) nil (1596 . 1598) nil (1595 . 1596) nil (1589 . 1594) nil ("R" . -1589) ((marker) . -1) 1590 nil (1587 . 1590) nil (1578 . 1587) ("RO" . -1578) ((marker) . -2) 1580 nil (1578 . 1580) nil (1570 . 1578) nil (1567 . 1570) nil ("P" . -1567) ((marker) . -1) 1568 nil (1566 . 1568) nil (1563 . 1566) nil (1562 . 1564) nil (1558 . 1562) nil (1553 . 1558) nil (1540 . 1553) nil (1522 . 1531) nil (1519 . 1522) nil (apply yas--take-care-of-redo [cl-struct-yas--snippet nil ([cl-struct-yas--field 1 1519 1531 nil nil nil t [cl-struct-yas--field 2 1532 1532 nil nil nil nil [cl-struct-yas--field 3 1540 1841 nil nil nil t [cl-struct-yas--exit 1845 nil]]]] [cl-struct-yas--field 2 1532 1532 nil nil nil nil [cl-struct-yas--field 3 1540 1841 nil nil nil t [cl-struct-yas--exit 1845 nil]]] [cl-struct-yas--field 3 1540 1841 nil nil nil t [cl-struct-yas--exit 1845 nil]]) [cl-struct-yas--exit 1845 nil] 38 nil [cl-struct-yas--field 3 1540 1841 nil nil nil t [cl-struct-yas--exit 1845 nil]] nil nil]) (1529 . 1531) (1524 . 1528) ("  " . 1524) (1511 . 1528) ("f" . 1511) ((marker) . -1) 1512 nil (1511 . 1512) nil (1509 . 1511) ("  " . 1508) (1508 . 1510) (1508 . 1509) ("  " . 1508) ((marker) . -2) 1510 nil (1507 . 1510) nil (2671 . 2672) nil (2664 . 2669) nil (2659 . 2664) nil (2658 . 2660) nil (2657 . 2659) nil (2652 . 2657) nil (2642 . 2652) (2643 . 2651) ("          " . 2642) (2642 . 2652) (2642 . 2643) ("        " . 2642) (2641 . 2650) nil (2640 . 2642) nil (2639 . 2640) nil (2636 . 2638) nil (2631 . 2636) nil (2625 . 2631) nil (2624 . 2626) nil (2621 . 2624) nil (2612 . 2621) (t 23206 30864 928670 854000) nil (2626 . 2627) nil (";" . -2626) ((marker) . -1) ((marker) . -1) 2627 (t 23206 30846 10347 769000) nil (2626 . 2627) nil (";" . -2626) ((marker) . -1) ((marker) . -1) 2627 (t 23206 30431 165842 993000) nil (2626 . 2627) nil (";" . -2626) ((marker) . -1) ((marker) . -1) 2627 (t 23206 30410 975558 29000) nil (2626 . 2627) nil (";" . -2626) ((marker) . -1) 2627 (t 23206 29921 601478 609000) nil (2621 . 2627) nil (2612 . 2621) nil (2611 . 2612) nil (2609 . 2611) nil (2599 . 2609) ("dra" . -2599) ((marker) . -3) 2602 nil (2601 . 2602) nil ("w" . -2601) ((marker) . -1) 2602 nil (2599 . 2602) nil (2590 . 2599) nil (2589 . 2590) nil (2584 . 2589) nil (2580 . 2583) nil (2579 . 2581) nil (2575 . 2578) nil (2574 . 2576) nil (2569 . 2574) nil (2560 . 2569) nil (2559 . 2560) nil (2555 . 2558) nil (2554 . 2556) nil (2550 . 2553) nil (2549 . 2551) nil (2541 . 2549) nil (2531 . 2540) ("target" . -2531) ((marker) . -6) 2537 nil (2531 . 2537) nil (2530 . 2532) nil (2520 . 2529) ("target" . -2520) ((marker) . -6) 2526 nil (2520 . 2526) nil (2519 . 2521) nil (2514 . 2519) nil (2506 . 2514) (2507 . 2513) ("        " . 2506) (2506 . 2514) (2506 . 2507) ("      " . 2506) (2505 . 2512) nil (2504 . 2506) nil (2503 . 2504) nil (2495 . 2502) nil (2485 . 2494) ("tar" . -2485) ((marker) . -3) 2488 nil (2485 . 2488) nil (2484 . 2486) nil (2474 . 2483) ("target" . -2474) ((marker) . -6) 2480 nil (2475 . 2480) nil (2474 . 2475) nil (2473 . 2475) nil (2468 . 2473) nil (2467 . 2469) nil (2464 . 2467) nil (2457 . 2464) nil (2419 . 2428) ("CO_COUNT" . 2419) ((marker) . -2) 2421 nil (2419 . 2421) nil ("R" . -2419) ((marker) . -1) ("O" . -2420) ((marker) . -1) ("W" . -2421) ((marker) . -1) 2422 nil (2406 . 2415) ("targetC" . -2406) ((marker) . -7) 2413 nil (2412 . 2413) nil ("R" . -2412) ((marker) . -1) ("o" . -2413) ((marker) . -1) ("w" . -2414) ((marker) . -1) 2415 nil (2389 . 2398) ("targetC" . -2389) ((marker) . -7) 2396 nil (2395 . 2396) nil ("R" . -2395) ((marker) . -1) ("o" . -2396) ((marker) . -1) ("w" . -2397) ((marker) . -1) 2398 nil (2379 . 2458) nil ("      if (targetRow < 0 || targetRow >= ROW_COUNT) {
        continue;
" . 2371) nil (2371 . 2442) nil ("      
" . 2379) ((marker) . -7) nil ("i" . -2385) ((marker) . -1) ("f" . -2386) ((marker) . -1) (" " . -2387) ((marker) . -1) (")" . 2388) ("(" . -2388) ((marker) . -1) 2389 nil (2388 . 2390) nil (2385 . 2388) nil (2378 . 2385) nil (2362 . 2370) nil (2361 . 2362) nil (2353 . 2361) (2354 . 2360) ("        " . 2353) (2353 . 2361) (2353 . 2354) ("      " . 2353) ((marker) . -6) (2352 . 2359) nil (2351 . 2353) nil (2350 . 2351) nil (2340 . 2349) ("RO" . -2340) ((marker) . -2) ((marker*) . 2) 2342 nil (2339 . 2342) nil (2336 . 2339) nil (2327 . 2336) ("target" . -2327) ((marker) . -6) ((marker*) . 6) 2333 nil (2326 . 2333) nil (2319 . 2326) nil (2310 . 2319) ("targetR" . -2310) ((marker) . -7) ((marker*) . 7) 2317 nil (2310 . 2317) nil (2309 . 2311) nil (2308 . 2309) nil (2306 . 2308) nil (2299 . 2306) nil (2298 . 2299) nil (2296 . 2297) nil (2295 . 2297) nil (2293 . 2294) nil (2292 . 2294) nil (2290 . 2292) nil ("K" . -2290) ((marker) . -1) 2291 nil (2288 . 2291) nil (2284 . 2288) nil (2276 . 2284) nil (2270 . 2276) nil (2263 . 2270) nil (2262 . 2263) nil (2260 . 2261) nil (2259 . 2261) nil (2257 . 2258) nil (2256 . 2258) nil (2249 . 2256) nil (2241 . 2249) nil (2234 . 2241) nil (1915 . 1919) nil (1914 . 1915) nil ("r" . -1914) ((marker) . -1) ("t" . -1915) ((marker) . -1) 1916 nil (1907 . 1916) nil (1898 . 1907) nil (1894 . 1898) nil (1889 . 1894) nil (1887 . 1889) nil (1883 . 1887) nil (1878 . 1883) nil (2187 . 2193) (2188 . 2192) ("      " . 2187) (2187 . 2193) (2187 . 2188) ("    " . 2187) (2186 . 2191) nil (2185 . 2187) nil (2184 . 2185) nil (2178 . 2183) nil (2169 . 2178) nil (2163 . 2169) nil (2156 . 2163) nil (2155 . 2157) nil (2151 . 2155) nil (2147 . 2151) ("    " . 2146) (2146 . 2150) (2146 . 2147) ("    " . 2146) ((marker) . -4) 2150 nil (2145 . 2150) nil (521 . 523) nil ("-" . -521) ((marker) . -1) ("1" . -522) ((marker) . -1) 523 nil (528 . 529) nil ("," . -524) ((marker) . -1) 525 nil (507 . 508) nil (475 . 476) nil (488 . 489) nil (514 . 515) nil (514 . 515) nil ("0" . -514) ((marker) . -1) 515 nil (501 . 503) nil ("0" . -501) ((marker) . -1) 502 nil (504 . 505) nil ("-" . -504) ((marker) . -1) ("1" . -505) ((marker) . -1) 506 nil (491 . 492) nil ("-" . -491) ((marker) . -1) 492 nil (483 . 496) 482 nil (483 . 496) 482 nil (483 . 496) 482 nil (481 . 482) nil ("," . -480) ((marker) . -1) 481 nil (480 . 481) nil (475 . 480) nil (474 . 476) nil (470 . 474) (471 . 473) ("    " . 470) (470 . 474) (470 . 471) ("  " . 470) (469 . 472) nil (468 . 470) nil (462 . 468) nil (457 . 462) nil (454 . 457) nil (2045 . 2048) (t 23206 28632 374599 333000) (apply yas--snippet-revive 2045 2067 [cl-struct-yas--snippet nil ([cl-struct-yas--field 1 2057 2065 nil nil nil t [cl-struct-yas--exit 2067 nil]]) [cl-struct-yas--exit 2067 nil] 37 nil [cl-struct-yas--field 1 2057 2065 nil nil nil t [cl-struct-yas--exit 2067 nil]] nil nil]) nil ("
               " . 2065) ((marker) . -16) ((marker) . -16) ((marker* . 1) . 16) nil (2065 . 2081) nil (2062 . 2065) ("col" . -2062) ((marker) . -3) ((marker) . -3) ((marker*) . 3) 2065 nil (2058 . 2065) nil ("xxxxxxxxxx" . 2058) ((marker) . -10) (2057 . 2058) nil (apply yas--take-care-of-redo [cl-struct-yas--snippet nil ([cl-struct-yas--field 1 2057 2065 nil nil nil t [cl-struct-yas--exit 2067 nil]]) [cl-struct-yas--exit 2067 nil] 37 nil [cl-struct-yas--field 1 2057 2065 nil nil nil t [cl-struct-yas--exit 2067 nil]] nil nil]) (2045 . 2069) ("l" . 2045) ((marker) . -1) 2046 nil (2045 . 2046) nil (2040 . 2045) nil (2045 . 2046) (apply yas--snippet-revive 1744 2044 [cl-struct-yas--snippet nil ([cl-struct-yas--field 1 1752 1752 nil nil nil t [cl-struct-yas--field 2 1753 1754 nil nil nil t [cl-struct-yas--field 3 1762 2040 nil nil nil t [cl-struct-yas--exit 2044 nil]]]] [cl-struct-yas--field 2 1753 1754 nil nil nil t [cl-struct-yas--field 3 1762 2040 nil nil nil t [cl-struct-yas--exit 2044 nil]]] [cl-struct-yas--field 3 1762 2040 nil nil nil t [cl-struct-yas--exit 2044 nil]]) [cl-struct-yas--exit 2044 nil] 36 nil [cl-struct-yas--field 3 1762 2040 nil nil nil t [cl-struct-yas--exit 2044 nil]] nil nil]) nil (2027 . 2034) nil (2021 . 2027) (2022 . 2026) ("      " . 2021) (2021 . 2027) (2021 . 2022) ("    " . 2021) ((marker) . -4) (2020 . 2025) nil (2019 . 2021) nil (2018 . 2019) nil (2016 . 2017) nil (2010 . 2016) nil (2006 . 2009) nil (2005 . 2007) nil (2001 . 2004) nil (2000 . 2002) nil (1999 . 2000) nil (1995 . 1999) nil (1994 . 1996) nil (1991 . 1994) nil (1986 . 1991) nil (1985 . 1986) nil (1974 . 1984) ("ti" . -1974) ((marker) . -2) ((marker*) . 2) 1976 nil (1974 . 1976) nil (1970 . 1974) nil (1969 . 1971) nil (1964 . 1969) ("fl" . -1964) ((marker) . -2) ((marker) . -2) ((marker*) . 2) 1966 nil (1963 . 1966) nil (1959 . 1963) ("Ma" . -1959) ((marker) . -2) ((marker) . -2) ((marker*) . 2) 1961 nil (1959 . 1961) nil (1954 . 1959) nil (1953 . 1954) nil ("C" . -1953) ((marker) . -1) ((marker) . -1) ((marker*) . 1) ("O" . -1954) ((marker) . -1) ((marker) . -1) 1955 nil (1953 . 1955) nil (1948 . 1953) nil (1947 . 1948) nil (1935 . 1946) ("TI" . -1935) ((marker) . -2) ((marker*) . 2) 1937 nil (1935 . 1937) nil (1931 . 1935) nil (1930 . 1932) nil (1925 . 1930) nil (1917 . 1925) nil (1914 . 1917) nil (1909 . 1914) nil (1899 . 1909) nil (1893 . 1899) nil (1884 . 1893) nil ("u" . -1884) ((marker) . -1) ((marker) . -1) 1885 nil (1884 . 1885) nil (1879 . 1884) nil (1872 . 1879) nil (1866 . 1872) nil (1857 . 1866) nil (1853 . 1857) nil (1848 . 1853) nil (1847 . 1848) nil (1845 . 1847) nil (1841 . 1845) nil (1835 . 1841) nil (1828 . 1835) nil (1825 . 1828) nil (1815 . 1825) nil (1808 . 1815) nil (1803 . 1808) nil (1794 . 1803) nil (1790 . 1794) nil (1785 . 1790) nil (1776 . 1785) nil (1771 . 1776) nil (1765 . 1771) nil (1762 . 1765) nil (1753 . 1754) nil ("e" . -1752) ((marker) . -1) ((marker) . -1) 1753 nil (1752 . 1753) nil (apply yas--take-care-of-redo [cl-struct-yas--snippet nil ([cl-struct-yas--field 1 1752 1752 nil nil nil t [cl-struct-yas--field 2 1753 1754 nil nil nil t [cl-struct-yas--field 3 1762 2040 nil nil nil t [cl-struct-yas--exit 2044 nil]]]] [cl-struct-yas--field 2 1753 1754 nil nil nil t [cl-struct-yas--field 3 1762 2040 nil nil nil t [cl-struct-yas--exit 2044 nil]]] [cl-struct-yas--field 3 1762 2040 nil nil nil t [cl-struct-yas--exit 2044 nil]]) [cl-struct-yas--exit 2044 nil] 36 nil [cl-struct-yas--field 3 1762 2040 nil nil nil t [cl-struct-yas--exit 2044 nil]] nil nil]) (1762 . 1764) (1757 . 1761) ("  " . 1757) ((marker) . -2) ((marker) . -2) (1744 . 1761) ("f" . 1744) ((marker) . -1) 1745 nil (1742 . 1745) nil (1736 . 1741) nil (1735 . 1737) nil (1734 . 1736) nil (1718 . 1734) ("add" . -1718) ((marker) . -3) 1721 nil (1717 . 1721) nil (1711 . 1717) ("ca" . -1711) ((marker) . -2) 1713 nil (1711 . 1713) nil (1709 . 1711) ("  " . 1708) (1708 . 1710) (1708 . 1709) ("  " . 1708) ((marker) . -2) 1710 nil (1707 . 1710) (t 23206 27926 464422 382000) nil ("          " . 1404) (1404 . 1414) (1404 . 1405) nil ("          
" . 1404) nil (1177 . 1404) nil ("        sx = (tiles[row][col] % COL_COUNT) * TILE_WIDTH;
        sy = Math.floor((tiles[row][col] / COL_COUNT)) * TILE_HEIGHT;
        context.drawImage(image, sx, sy, TILE_WIDTH, TILE_HEIGHT, dx, dy, TILE_WIDTH, TILE_HEIGHT);
" . 1198) ((marker) . -227) ((marker) . -227) 1425 nil (1177 . 1187) (1178 . 1186) ("          " . 1177) (1177 . 1187) (1177 . 1178) ("        " . 1177) (1176 . 1185) nil (1175 . 1177) nil (1169 . 1175) nil (1127 . 1158) nil (1126 . 1128) nil (1123 . 1126) nil (1122 . 1123) nil ("r" . -1122) ((marker) . -1) 1123 nil (1117 . 1123) nil (1115 . 1117) nil ("s" . -1115) ((marker) . -1) ("t" . -1116) ((marker) . -1) 1117 nil (1113 . 1117) nil (1110 . 1113) nil (1099 . 1110) nil (1098 . 1099) nil ("," . -1098) ((marker) . -1) 1099 nil (1098 . 1099) nil (1091 . 1097) nil (1090 . 1091) nil (1089 . 1091) nil (1084 . 1089) nil (1076 . 1084) nil ("," . -1076) ((marker) . -1) 1077 nil (1076 . 1077) nil (1074 . 1076) nil ("n" . -1074) ((marker) . -1) 1075 nil (1069 . 1075) nil (1059 . 1069) (1060 . 1068) ("          " . 1059) (1059 . 1069) (1059 . 1060) ("        " . 1059) (1058 . 1067) nil (1057 . 1059) nil (1056 . 1057) nil (1048 . 1055) nil (1044 . 1047) nil (1043 . 1045) nil (1041 . 1042) nil (1039 . 1041) nil (1038 . 1040) nil (1033 . 1038) nil (1032 . 1034) nil (1029 . 1032) nil (1020 . 1029) nil ("
" . 868) ((marker) . -1) nil ("
" . 868) nil ("    var h = 70;" . 868) nil ("
" . 868) nil ("    var w = 70;" . 868) nil (714 . 720) nil (709 . 713) nil (700 . 709) ("CO" . -700) ((marker) . -2) 702 nil (701 . 702) nil (700 . 701) nil (699 . 701) nil (697 . 698) nil (696 . 697) nil ("1" . -696) ((marker) . -1) 697 nil (694 . 697) nil (685 . 694) ("RO" . -685) ((marker) . -2) 687 nil (685 . 687) nil (684 . 686) nil (679 . 684) nil (674 . 679) (t 23206 27188 211199 51000) nil (453 . 454) nil (444 . 453) ("RO" . -444) ((marker) . -2) 446 nil (444 . 446) nil (441 . 444) nil (431 . 441) ("PI" . -431) ((marker) . -2) 433 nil (431 . 433) nil (428 . 431) nil (417 . 428) ("TI" . -417) ((marker) . -2) 419 nil (417 . 419) nil (413 . 417) nil ("V" . -413) ((marker) . -1) ("A" . -414) ((marker) . -1) ("R" . -415) ((marker) . -1) 416 nil (413 . 416) nil (410 . 413) nil (409 . 410) nil (400 . 409) ("CO" . -400) ((marker) . -2) 402 nil (397 . 402) nil (388 . 397) ("PI" . -388) ((marker) . -2) 390 nil (389 . 390) nil ("P" . -389) ((marker) . -1) 390 nil (385 . 390) nil (375 . 385) ("TILE_WI" . -375) ((marker) . -7) 382 nil (375 . 382) nil (371 . 375) nil (368 . 371) nil (355 . 361) nil ("W" . -355) ((marker) . -1) ("I" . -356) ((marker) . -1) ("D" . -357) ((marker) . -1) ("T" . -358) ((marker) . -1) ("H" . -359) ((marker) . -1) 360 nil (345 . 368) 344 nil (341 . 344) nil (332 . 341) nil (324 . 332) nil (321 . 324) nil (1076 . 1086) nil ("w" . -1076) ((marker) . -1) 1077 nil (1043 . 1053) nil ("w" . -1043) ((marker) . -1) 1044 nil (1046 . 1057) nil ("h" . -1046) ((marker) . -1) 1047 nil (1060 . 1071) nil ("h" . -1060) ((marker) . -1) 1061 nil (989 . 1000) nil ("h" . -989) ((marker) . -1) 990 nil (920 . 930) nil ("w" . 920) ((marker . 1) . -1) ((marker) . -1) nil (870 . 873) nil (862 . 870) nil ("h" . -862) ((marker) . -1) 863 nil (838 . 841) nil (831 . 838) nil ("w" . -831) ((marker) . -1) 832 (t 23206 26434 287771 49000) nil (964 . 972) ("    " . 964) (904 . 912) ("    " . 904) (856 . 864) ("    " . 856) 1032 nil ("  " . -1030) ((marker) . -2) (1032 . 1033) nil (1027 . 1032) nil ("  " . -1026) ((marker) . -2) (1028 . 1029) nil (1022 . 1028) (1014 . 1020) ("  " . 1014) (1017 . 1018) nil ("
" . 956) nil ("v" . -904) ((marker) . -1) ("a" . -905) ((marker) . -1) ("r" . -906) ((marker) . -1) (" " . -907) ((marker) . -1) 908 nil ("v" . -860) ((marker) . -1) ("a" . -861) ((marker) . -1) 862 nil ("r" . -862) ((marker) . -1) (" " . -863) ((marker) . -1) 864 nil ("
" . 856) nil (838 . 842) nil (816 . 820) nil ("v" . -834) ((marker) . -1) ("a" . -835) ((marker) . -1) ("r" . -836) ((marker) . -1) (" " . -837) ((marker) . -1) 838 nil ("v" . -816) ((marker) . -1) ("a" . -817) ((marker) . -1) ("r" . -818) ((marker) . -1) (" " . -819) ((marker) . -1) 820 nil ("
" . 766) nil ("      tiles[row] = [];" . 766) nil (722 . 835) nil (672 . 687) nil ("    tiles[row][col] =6;" . 672) nil (669 . 671) nil ("u" . -669) ((marker) . -1) 670 nil (669 . 670) nil (664 . 669) nil ("c" . -664) ((marker) . -1) ("o" . -665) ((marker) . -1) ("l" . -666) ((marker) . -1) (" " . -667) ((marker) . -1) ("=" . -668) ((marker) . -1) (" " . -669) ((marker) . -1) ("1" . -670) ((marker) . -1) (";" . -671) ((marker) . -1) 672 nil (" " . -655) ((marker) . -1) ("=" . -656) ((marker) . -1) (" " . -657) ((marker) . -1) ("2" . -658) ((marker) . -1) (";" . -659) ((marker) . -1) 660 nil (650 . 655) (t 23206 25545 715885 129000) nil (879 . 883) nil (878 . 879) nil (867 . 876) ("CO" . -867) ((marker) . -2) 869 nil (867 . 869) nil (864 . 867) nil (860 . 863) nil (859 . 861) nil (855 . 858) nil (854 . 856) nil (853 . 854) nil ("d" . -853) ((marker) . -1) 854 nil (849 . 854) nil (848 . 850) (847 . 849) nil (841 . 847) nil ("," . -841) ((marker) . -1) 842 nil (839 . 842) nil (837 . 839) nil (820 . 823) nil (818 . 820) nil (808 . 817) ("CO" . -808) ((marker) . -2) 810 nil (809 . 810) nil (805 . 809) nil (801 . 804) nil (800 . 802) nil (796 . 799) nil (795 . 797) nil (794 . 795) nil ("d" . -794) ((marker) . -1) 795 nil (793 . 795) nil (790 . 793) nil (789 . 791) nil (788 . 789) nil (793 . 802) nil (" " . -793) ((marker) . -1) (" " . -794) ((marker) . -1) (" " . -795) ((marker) . -1) (" " . -796) ((marker) . -1) 797 nil (788 . 797) (" " . 788) ((marker) . -1) 789))
