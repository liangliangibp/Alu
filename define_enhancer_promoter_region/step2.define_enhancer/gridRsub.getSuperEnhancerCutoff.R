## gridRsub.getSuperEnhancerCutoff.R

## R code for active gene
numPts_below_line = function(myVector,slope,x){
  yPt = myVector[x]; b = yPt-(slope*x)
  xPts = 1:length(myVector)
  return(sum(myVector <= (xPts*slope+b)))
}

fopt = function(v) {
  v = sort(v); v[v<0] = 0
  slope = (max(v)-min(v))/length(v)
  x = floor(optimize(numPts_below_line, lower = 1, upper = length(v), myVector=v, slope=slope)$minimum)
  # length(v) - x + 1
  v[x]
}

usage = 'Rscript gridRsub.getSuperEnhancerCutoff.R <genecvg.bed>\n'
args = commandArgs(TRUE)

if(length(args) == 1) {
  x = read.table(args[1], as.is = T, sep = '\t')[,5]
  cat(fopt(x[x>10]),'\n')
} else {
  cat(usage)
}
