part of patsubst.top_level;

/**
 * Creates and returns string pattern substitution.
 */
PatSubst patsubst(String pattern, String replacement) {
  return new PatSubst(pattern, replacement);
}
