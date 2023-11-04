exports.getPosts=(req,res,next)=>{
    console.log("fgdfg");
    res.status(200).json({posts:[{title:"first post",content:"this is hte content"}]})
};

exports.createPost=(req,res,next)=>{
    const title=req.body.title;
    const content=req.body.content;

    res.status(201).json({message:"created sucsessfully",post:{
                                                                id:new Date().toISOString(),
                                                                title:title,
                                                                content:content
                                                            }
                        })
}