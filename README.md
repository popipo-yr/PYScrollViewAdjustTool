
---
#PYScrollViewAdjustTool
-------------

在UIScrollView容器中键盘弹出和隐藏时,改变子视图到适当位置进行展示

####示例:  
![image](https://github.com/popipo-yr/PYScrollViewAdjustTool/blob/master/Demo/1.gif)
![image](https://github.com/popipo-yr/PYScrollViewAdjustTool/blob/master/Demo/2.gif)
![image](https://github.com/popipo-yr/PYScrollViewAdjustTool/blob/master/Demo/3.gif)


### 下载安装
目前没有支持cocospods,下载PYScrollViewAdjustTool加入头文件就可使用

###使用方法

```
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [PYScrollViewAdjustTool adjustViewToKeyboardTop:textField 
    								   atScrollView:_scrollView];
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [PYScrollViewAdjustTool restoreView:textField];
    return YES;
}
```

### 注意事项
这个工具类只会改变视图在scrollview中的位置,不会更改scrollview的位置,所以如果scrollview整个视图在键盘范围下,则不会有作用.
