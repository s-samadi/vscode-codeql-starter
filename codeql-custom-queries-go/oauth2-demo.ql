import go

//This is our source
predicate xAuthSource(CallExpr c, string funcName, QualifiedName qn, Expr arg) {
  funcName = c.getCalleeName() and
  funcName = "Get" and
  c.getCalleeExpr() = qn and
  arg = c.getAnArgument() and
  arg.(StringLit).getValue() = "X-Auth-Request-Redirect"
}

//This is the sink we are looking for
//strings.HasPrefix(redirect, “/”) && !strings.HasPrefix(redirect, “//”)
//.HasPrefix(checked,"string")
class HasPrefix extends CallExpr {
  Expr checked;
  string prefix;

  HasPrefix() {
    this.getTarget().getName() = "HasPrefix" and
    this.getArgument(0) = checked and
    this.getArgument(1).(StringLit).getStringValue() = prefix
  }

  Expr getBaseString() { result = checked }

  string getSubString() { result = prefix }
}

from HasPrefix call, Expr checked, string prefix
where call.getBaseString() = checked and call.getSubString() = prefix
select call, checked, prefix
