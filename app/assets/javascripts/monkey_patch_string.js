String.prototype.rightJustify = function( length, char ) {
  var fill = [];
  while ( fill.length + this.length < length ) {
    fill[fill.length] = char;
  }
  return this + fill.join('');
};

String.prototype.leftJustify = function( length, char ) {
  var fill = [];
  while ( fill.length + this.length < length ) {
    fill[fill.length] = char;
  }
  return fill.join('') + this;
}