String imgPath;
PImage img, newImg;
int originalWidth, originalHeight, resizedWidth, resizedHeight;
float[] redPx = new float[256];
float[] greenPx = new float[256];
float[] bluePx = new float[256];
float[] luminosite = new float[256];
float redMax, greenMax, blueMax, luminositeMax, valMax;
float tmp, coef;
boolean echelle;

void setup() {
  size(1200, 800);
  background(20);
  imgPath = "picture.jpg";
  echelle = true; //Les histogrammes doivent-ils tous être à la même échelle ?
  coef = 1.5; //Coefficient de contraste
  img = loadImage(imgPath);
  newImg = loadImage(imgPath);
  originalWidth = img.width;
  originalHeight = img.height;
  
  /* Calcul une nouvelle dimension pour l'image afin de l'adapter à l'écran */
  resizedWidth = img.width;
  resizedHeight = img.height;
  while (resizedWidth > width/2 && resizedWidth > 300) {
    resizedWidth=resizedWidth/2;
    resizedHeight=resizedHeight/2;
  }
  while (resizedHeight > height-42*2 && resizedWidth > 300) {
    resizedWidth=resizedWidth/2;
    resizedHeight=resizedHeight/2;
  }
  if (resizedWidth < 300) {
    resizedWidth=resizedWidth*2;
    resizedHeight=resizedHeight*2;
  }
}

void draw() {
  background(20);

  ///** DEBUT TRAITEMENT IMAGE ORIGINALE **///
  /* Place la valeur des composantes RGB et la valeur de la luminosité de chaque pixel de l'image dans différents tableaux */
  redMax = 0;
  greenMax = 0;
  blueMax = 0;
  luminositeMax = 0;

  for (int i=0; i<256; i++) {
    redPx[i] = 0;
    greenPx[i] = 0;
    bluePx[i] = 0;
    luminosite[i] = 0;
  }

  for (int j=0; j<img.width*img.height; j++) {
    redPx[int(red(img.pixels[j]))]++;
    greenPx[int(green(img.pixels[j]))]++;
    bluePx[int(blue(img.pixels[j]))]++;

    if (redPx[int(red(img.pixels[j]))] > redMax && redPx[int(red(img.pixels[j]))] < img.width*img.height/50) {
      redMax = redPx[int(red(img.pixels[j]))];
    }
    if (greenPx[int(green(img.pixels[j]))] > greenMax && greenPx[int(green(img.pixels[j]))] < img.width*img.height/50) {
      greenMax = greenPx[int(green(img.pixels[j]))];
    }
    if (bluePx[int(blue(img.pixels[j]))] > blueMax && bluePx[int(blue(img.pixels[j]))] < img.width*img.height/50) {
      blueMax = bluePx[int(blue(img.pixels[j]))];
    }
  }
  for (int k=0; k<256; k++) {
    luminosite[k] = 0.3*redPx[k]+0.6*greenPx[k]+0.1*bluePx[k];
    if (luminosite[k] > luminositeMax && luminosite[k] < img.width*img.height/50) {
      luminositeMax = luminosite[k];
    }
  }
  valMax = 1;
  if (redMax > valMax) {
    valMax = redMax;
  }
  if (greenMax > valMax) {
    valMax = greenMax;
  }
  if (blueMax > valMax) {
    valMax = blueMax;
  }
  if (luminositeMax > valMax) {
    valMax = luminositeMax;
  }

  /* Affichage de l'image à l'écran */
  img.resize(resizedWidth, resizedHeight);
  image(img, 42, 42);
  img = loadImage(imgPath);
  textSize(12);
  fill(225);
  text("Image originale", 42, 36);

  /* Affichage des histogrammes de l'image à l'écran */
  pushMatrix();
  translate(resizedWidth+69, 150+42);
  stroke(225);
  fill(0);
  rect(-1, 1, 255+2, -150-2);
  rect(-1, 1+175, 255+2, -150-2);
  rect(-1, 1+175*2, 255+2, -150-2);
  rect(-1, 1+175*3, 255+2, -150-2);
  for (int l=0; l<256; l++) {
    stroke(255, 0, 0);
    if (echelle) {
      tmp = redPx[l]/valMax*150;
    } else {
      tmp = redPx[l]/redMax*150;
    }
    if (tmp > 150) { //Si la hauteur de l'histogramme est dépassée (150px) alors on trace une ligne de hauteur = 150px afin que celle-ci ne sorte du cadre de l'histogramme
      tmp = 150;
    }
    line(l, 0, l, -tmp);

    stroke(0, 255, 0);
    if (echelle) {
      tmp = greenPx[l]/valMax*150;
    } else {
      tmp = greenPx[l]/greenMax*150;
    }
    if (tmp > 150) { //Si la hauteur de l'histogramme est dépassée (150px) alors on trace une ligne de hauteur = 150px afin que celle-ci ne sorte du cadre de l'histogramme
      tmp = 150;
    }
    line(l, 175, l, -tmp+175);

    stroke(0, 0, 255);
    if (echelle) {
      tmp = bluePx[l]/valMax*150;
    } else {
      tmp = bluePx[l]/blueMax*150;
    }
    if (tmp > 150) { //Si la hauteur de l'histogramme est dépassée (150px) alors on trace une ligne de hauteur = 150px afin que celle-ci ne sorte du cadre de l'histogramme
      tmp = 150;
    }
    line(l, 175*2, l, -tmp+175*2);

    stroke(255);
    if (echelle) {
      tmp = (0.3*redPx[l]+0.6*greenPx[l]+0.1*bluePx[l])/valMax*150;
    } else {
      tmp = (0.3*redPx[l]+0.6*greenPx[l]+0.1*bluePx[l])/luminositeMax*150;
    }
    if (tmp > 150) { //Si la hauteur de l'histogramme est dépassée (150px) alors on trace une ligne de hauteur = 150px afin que celle-ci ne sorte du cadre de l'histogramme
      tmp = 150;
    }
    line(l, 175*3, l, -tmp+175*3);
  }
  popMatrix();
  fill(225);
  text("Histogrammes de l'image originale", resizedWidth+69, 36);
  fill(255, 0, 0);
  text("Composante rouge", resizedWidth+69+75, 36+170);
  fill(0, 255, 0);
  text("Composante verte", resizedWidth+69+75, 36+170*2+5);
  fill(0, 0, 255);
  text("Composante bleue", resizedWidth+69+75, 36+170*3+10);
  fill(255);
  text("Luminosité", resizedWidth+69+100, 36+170*4+15);
  ///** FIN TRAITEMENT IMAGE ORIGINALE **///



  ///** DEBUT TRAITEMENT IMAGE RETOUCHEE **///
  /* Crée une nouvelle image (copie de la première image) et retouche son contraste */
  for (int m=0; m<originalHeight; m++) {
    for (int n=0; n<originalWidth; n++) {
      newImg.set(n, m, color(int(127 + (int(red(img.get(n, m))) - 127)*coef), int(127 + (int(green(img.get(n, m))) - 127)*coef), int(127 + (int(blue(img.get(n, m))) - 127)*coef)));
    }
  }

  /* Place la valeur des composantes RGB et la valeur de la luminosité de chaque pixel de l'image dans différents tableaux */
  for (int o=0; o<256; o++) {
    redPx[o] = 0;
    greenPx[o] = 0;
    bluePx[o] = 0;
    luminosite[o] = 0;
  }

  for (int p=0; p<newImg.width*newImg.height; p++) {
    redPx[int(red(newImg.pixels[p]))]++;
    greenPx[int(green(newImg.pixels[p]))]++;
    bluePx[int(blue(newImg.pixels[p]))]++;
  }

  /* Affichage de l'image*/
  newImg.resize(resizedWidth, resizedHeight);
  image(newImg, 42, resizedHeight+42*2+1);
  newImg = loadImage(imgPath);
  fill(225);
  text("Nouvelle image contrastée", 42, resizedHeight+42*2-5);

  /* Affichage des histogrammes de l'image à l'écran */
  pushMatrix();
  translate(resizedWidth+69+(250+42), 150+42);
  stroke(225);
  fill(0);
  rect(-1, 1, 255+2, -150-2);
  rect(-1, 1+175, 255+2, -150-2);
  rect(-1, 1+175*2, 255+2, -150-2);
  rect(-1, 1+175*3, 255+2, -150-2);
  for (int r=0; r<256; r++) {
    stroke(255, 0, 0);
    if (echelle) {
      tmp = redPx[r]/valMax*150;
    } else {
      tmp = redPx[r]/redMax*150;
    }
    if (tmp > 150) { //Si la hauteur de l'histogramme est dépassée (150px) alors on trace une ligne de hauteur = 150px afin que celle-ci ne sorte du cadre de l'histogramme
      tmp = 150;
    }
    line(r, 0, r, -tmp);

    stroke(0, 255, 0);
    if (echelle) {
      tmp = greenPx[r]/valMax*150;
    } else {
      tmp = greenPx[r]/greenMax*150;
    }
    if (tmp > 150) { //Si la hauteur de l'histogramme est dépassée (150px) alors on trace une ligne de hauteur = 150px afin que celle-ci ne sorte du cadre de l'histogramme
      tmp = 150;
    }
    line(r, 175, r, -tmp+175);

    stroke(0, 0, 255);
    if (echelle) {
      tmp = bluePx[r]/valMax*150;
    } else {
      tmp = bluePx[r]/blueMax*150;
    }
    if (tmp > 150) { //Si la hauteur de l'histogramme est dépassée (150px) alors on trace une ligne de hauteur = 150px afin que celle-ci ne sorte du cadre de l'histogramme
      tmp = 150;
    }
    line(r, 175*2, r, -tmp+175*2);

    stroke(255);
    if (echelle) {
      tmp = (0.3*redPx[r]+0.6*greenPx[r]+0.1*bluePx[r])/valMax*150;
    } else {
      tmp = (0.3*redPx[r]+0.6*greenPx[r]+0.1*bluePx[r])/luminositeMax*150;
    }
    if (tmp > 150) { //Si la hauteur de l'histogramme est dépassée (150px) alors on trace une ligne de hauteur = 150px afin que celle-ci ne sorte du cadre de l'histogramme
      tmp = 150;
    }
    line(r, 175*3, r, -tmp+175*3);
  }
  popMatrix();
  fill(225);
  text("Histogrammes de la nouvelle image", resizedWidth+69+(250+42), 36);
  fill(255, 0, 0);
  text("Composante rouge", resizedWidth+69+(250+42)+75, 36+170);
  fill(0, 255, 0);
  text("Composante verte", resizedWidth+69+(250+42)+75, 36+170*2+5);
  fill(0, 0, 255);
  text("Composante bleue", resizedWidth+69+(250+42)+75, 36+170*3+10);
  fill(255);
  text("Luminosité", resizedWidth+69+(250+42)+100, 36+170*4+15);
  ///** FIN TRAITEMENT IMAGE RETOUCHEE **///

  fill(255);
  text("Dimensions de l'image : "+originalWidth+" x "+originalHeight+" pixels", 5, 14);
  fill(255, 255, 0);
  text("Coefficient de contraste : "+nfc(coef, 1), 42, resizedHeight*2+42*3-18);
  fill(255);
  text("Flèche de gauche : réduit le coefficient de 0.1", 42, resizedHeight*2+42*3);
  text("Flèche de droite : augmente le coefficient de 0.1", 42, resizedHeight*2+42*3+18);
}

void keyPressed() {
  if (keyCode == LEFT) {
    coef = coef-0.1;
  } else if (keyCode == RIGHT) {
    coef = coef+0.1;
  }
}