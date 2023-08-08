const {expect} = require('chai');
const {ethers} = require('hardhat');

describe("Blog", function (){
    it("Should create a post", async function (){
        const Blog = await ethers.getContractFactory("Blog");
        const blog = await Blog.deploy("My blog");
        await blog.deployed();
        await blog.createPost("My first post", "This is my first post");

        const posts = await blog.fetchPosts()
        expect(posts[0].title).to.equal("My first post");
    })
    it("Should edit a Post", async function (){ 
        const Blog = await ethers.getContractFactory("Blog");
        const blog = await Blog.deploy("My blog");
        await blog.deployed();
        await blog.createPost("My second post", "This is my second post")
        await blog.updatePost(1, "My updated post", "This is my updated post", true);

        posts = await blog.fetchPosts()
        expect(posts[0].title).to.equal("My updated post");
        
    })

    it("Should add update the name", async function() {
        const Blog = await ethers.getContractFactory("Blog");
        const blog = await Blog.deploy("My blog");
        await blog.deployed();

        expect (await blog.name()).to.equal("My blog");
        await blog.updateName("My new blog");
        expect (await blog.name()).to.equal("My new blog");
    })

})