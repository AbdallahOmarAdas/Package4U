const express=require('express');
const feedsController=require('../controller/feedsController')
const router=express.Router();

router.get('/posts',feedsController.getPosts)
router.post('/post',feedsController.createPost)
module.exports=router;