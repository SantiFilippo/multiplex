perm <-
function (x, clu, rev, lbs) 
{
    if (isTRUE(is.array(x) == TRUE) == FALSE && isTRUE(is.data.frame(x) == 
        TRUE) == FALSE && isTRUE(is.matrix(x) == TRUE) == FALSE) 
        stop("'x' must be an array, matrix, or a data frame object.")
    if (missing(clu) == TRUE || isTRUE(length(unlist(clu)) != 
        dim(x)[1]) == TRUE) 
        stop("'clu' is missing or it does not match the order of 'x'.")
    ifelse(missing(rev) == FALSE && isTRUE(rev == TRUE) == TRUE, 
        rev <- TRUE, rev <- FALSE)
    if (is.character(clu) == TRUE || is.factor(clu) == TRUE) {
        tmp <- as.vector(clu)
        for (i in seq_len(nlevels(factor(clu)))) {
            tmp[which(levels(factor(clu))[i] == tmp)] <- i
        }
        rm(i)
        cls <- as.numeric(tmp)
        rm(tmp)
    }
    else if (is.numeric(clu) == TRUE) {
        ifelse(isTRUE(0L %in% as.numeric(levels(factor(clu)))) == 
            TRUE, cls <- clu + 1L, cls <- clu)
    }
    else if (is.data.frame(clu) == TRUE || is.list(clu) == TRUE) {
        cls <- as.vector(unlist(clu))
    }
    else {
        cls <- clu
    }
    ifelse(NA %in% cls, cls[which(is.na(cls))] <- max(as.numeric(levels(factor(cls)))) + 
        1L, NA)
    or <- list()
    for (i in as.numeric(unique(cls))) {
        or[[i]] <- which(cls == i)
    }
    rm(i)
    if (isTRUE(any(is.na(unlist(or)))) == TRUE) {
        for (i in seq_len(length(or))) {
            ifelse(isTRUE(is.null(or[[i]])) == TRUE, or[[i]] <- NA, 
                NA)
        }
        rm(i)
        nor <- as.vector(stats::na.omit(unlist(or)))
    }
    else {
        nor <- order(unlist(or))
    }
    if (isTRUE(is.na(dim(x)[3]) == TRUE)) {
        prm <- vector()
        for (i in nor) {
            prm[nor[i]] <- i
        }
        rm(i)
        ifelse(isTRUE(rev == TRUE) == TRUE, px <- x[rev(prm), 
            rev(prm)], px <- x[prm, prm])
        ifelse(missing(lbs) == FALSE && isTRUE(length(lbs) == 
            dim(x)[1]) == TRUE, dimnames(px)[[1]] <- dimnames(px)[[2]] <- lbs, 
            NA)
        return(px)
    }
    else {
        px <- x
        for (k in seq_len(dim(px)[3])) {
            prm <- vector()
            for (i in nor) {
                prm[nor[i]] <- i
            }
            rm(i)
            px[, , k] <- px[prm, prm, k]
        }
        rm(k)
        if (missing(lbs) == FALSE && isTRUE(length(lbs) == dim(x)[1]) == 
            TRUE) {
            dimnames(px)[[1]] <- dimnames(px)[[2]] <- lbs
        }
        else if (is.null(dimnames(x)[[1]]) == FALSE) {
            Lbs <- vector()
            length(Lbs) <- length(clu)
            for (i in seq_len(length(nor))) Lbs[i] <- dimnames(x)[[1]][which(nor == 
                i)]
            dimnames(px)[[1]] <- dimnames(px)[[2]] <- Lbs
        }
        else {
            NA
        }
        ifelse(isTRUE(is.null(dimnames(x)[[3]]) == FALSE), dimnames(px)[[3]] <- dimnames(x)[[3]], 
            NA)
        return(px)
    }
}
