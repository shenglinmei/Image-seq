

MinMax=function (data, min, max) {
  data2 <- data
  data2[data2 > max] <- max
  data2[data2 < min] <- min
  return(data2)
}

PercentAbove=function (x, threshold) {
  return(length(x = x[x > threshold])/length(x = x))
}



Dotfig=function(features,exp2,ano2,cols = c("blue","white", "red"), #c("lightgrey", "blue"), 
                col.min = -2.5,
                col.max = 2.5,
                dot.min = 0,
                dot.scale = 6,
                group.by = NULL,
                split.by = NULL,
                scale = TRUE,
                scale.by = 'radius',
                scale.min = NA,
                scale.max = NA){
  
  data.features=data.frame(as.matrix(t(exp2[features,])),'id'=ano2)
  
  
  if(is.null(levels(ano2))){
    data.features$id <- factor(x = data.features$id)
  }
  
  
  id.levels <- levels(x = data.features$id)
  data.features$id <- as.vector(x = data.features$id)
  
  
  
  data.plot <- lapply(
    X = unique(x = data.features$id),
    FUN = function(ident) {
      data.use <- data.features[data.features$id == ident, 1:(ncol(x = data.features) - 1), drop = FALSE]
      avg.exp <- apply(
        X = data.use,
        MARGIN = 2,
        FUN = function(x) {
          return(mean(x = expm1(x = x)))
        }
      )
      pct.exp <- apply(X = data.use, MARGIN = 2, FUN = PercentAbove, threshold = 0)
      return(list(avg.exp = avg.exp, pct.exp = pct.exp))
    }
  )
  
  
  names(x = data.plot) <- unique(x = data.features$id)
  data.plot <- lapply(
    X = names(x = data.plot),
    FUN = function(x) {
      data.use <- as.data.frame(x = data.plot[[x]])
      data.use$features.plot <- rownames(x = data.use)
      data.use$id <- x
      return(data.use)
    }
  )
  
  
  data.plot <- do.call(what = 'rbind', args = data.plot)
  
  
  
  avg.exp.scaled <- sapply(
    X = unique(x = data.plot$features.plot),
    FUN = function(x) {
      data.use <- data.plot[data.plot$features.plot == x, 'avg.exp']
      if (scale) {
        data.use <- scale(x = data.use)
        data.use <- MinMax(data = data.use, min = col.min, max = col.max)
      } else {
        data.use <- log(x = data.use)
      }
      return(data.use)
    }
  )
  
  
  avg.exp.scaled <- as.vector(x = t(x = avg.exp.scaled))
  
  data.plot$avg.exp.scaled <- avg.exp.scaled
  
  
  data.plot$features.plot <- factor(
    x = data.plot$features.plot,
    levels = rev(x = features)
  )
  data.plot$pct.exp[data.plot$pct.exp < dot.min] <- NA
  data.plot$pct.exp <- data.plot$pct.exp * 100
  
  
  color.by <- ifelse(test = is.null(x = split.by), yes = 'avg.exp.scaled', no = 'colors')
  if (!is.na(x = scale.min)) {
    data.plot[data.plot$pct.exp < scale.min, 'pct.exp'] <- scale.min
  }
  if (!is.na(x = scale.max)) {
    data.plot[data.plot$pct.exp > scale.max, 'pct.exp'] <- scale.max
  }
  data.plot$id=ordered(as.factor(data.plot$id),levels=levels(ano2))  
  plot <- ggplot(data = data.plot, mapping = aes_string(y = 'features.plot', x = 'id')) +
    # geom_point(mapping = aes_string(size = 4, color = color.by)) +
    geom_point(mapping = aes_string(size = 'pct.exp', color = color.by)) +
    scale_size(range = c(0, dot.scale), limits = c(scale.min, scale.max)) +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +
    guides(size = guide_legend(title = 'Percent Expressed')) +
    labs(
      x = 'Features',
      y = ifelse(test = is.null(x = split.by), yes = 'Identity', no = 'Split Identity')
    ) +
    theme_cowplot()
  print(cols[1])
  print(cols[2])
  print(cols[3])
  plot=plot+ theme(axis.text.x = element_text(angle = 45, hjust = 1))
  plot <- plot + scale_color_gradient2(low = cols[1], high = cols[3],mid = cols[2], midpoint = 0)
  return(plot)
}
