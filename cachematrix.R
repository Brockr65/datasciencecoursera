## The functions work together to set and cache a matrix.   
## When a matrix is defined, it is then stored, it's inverse is 
##  calculated, and that inverse value is stored as well.  

## This function takes a create matrix and caches it.  It also creates
## a list of functions that will be called to solve for the the inverse
## of the stored matrix.

makeCacheMatrix <- function(x=numeric()){
  m <- NULL
  set <- function(y){
    x <<- y
    m <<- NULL
  }
  get <- function() x
  setinverse <- function(solve) m <<- solve
  getinverse <- function() m
  list(set=set, get=get, setinverse=setinverse, getinverse=getinverse)
}

## This function checks to see if a cached matrix is available (from the
## first function).  If a function is available it calculates the inverse 
## of the matrix.

cacheSolve <- function(x, ...) {
  m <- x$getinverse()
  if(!is.null(m)) {
    message("getting cached data")
    return(m)
  }
  data <- x$get()
  m <- solve(data, ...)
  x$setinverse(m)
  m
}

