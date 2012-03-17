require("coffee-script");

var Lotto = require("lotto");
var lotto = new Lotto();

try {
  ret = lotto.exec(process.argv.slice(2));
} catch(err) {
  ret = "Erreur: " + err
}
console.log(ret)
   

