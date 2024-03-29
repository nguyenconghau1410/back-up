import React, { useState, useEffect } from "react";
import { Avatar, Card, Typography, Divider, Row, Col, Image, Button, Modal, Alert, App } from "antd";
import { UserOutlined, CalendarOutlined, TagOutlined } from "@ant-design/icons";
import { base_url, formatDateTime } from "../config/constant";
import { formatDate } from "../config/constant";
import queryString from 'query-string';
import axios from 'axios';
import { Navigate, useNavigate } from "react-router-dom";
const PostDetails = () => {
  const navigate = useNavigate();
  const id = queryString.parse(window.location.search).id;
  const [postRelation, setDataPost] = useState([]);
  useEffect(() => {
    axios.get(`${base_url}/posts/get-by-id?id=${id}`)
      .then(response => {
        setDataPost(response.data)
      })
      .catch(error => {
        console.error(error)
      });
  }, [])
  //Modal
  const [isModalOpen, setIsModalOpen] = useState(false);
  const showModal = () => {
    setIsModalOpen(true);
  };
  const handleOk = () => {
    deletePost(postRelation.post?.id, postRelation.user?.id)
    setIsModalOpen(false);
  };
  const handleCancel = () => {
    setIsModalOpen(false);
  };
  // input
  const [inputValue, setInputValue] = useState('');

  const handleInputChange = (event) => {
    setInputValue(event.target.value);
  };
  const deletePost = async (postId, userId) => {
    try {
      const response = await axios.delete(`${base_url}/posts/delete-post?postId=${postId}`)
      if (response.status == 200) {
        alert("Delete success !")
        await pushNotify(userId)
      }
      else {
        { <Alert message="There was an error, try it again" type="error" /> }
        alert("There was an error, try it again !")
      }
    }
    catch (error) {
      console.log(error)
    }
  }
  const pushNotify = async (userId) => {
    try {
      const response = await axios.post(
        `${base_url}/notifications/add-notification`,
        {
          "userid": userId,
          "user": null,
          "content": inputValue,
          "timestamp": formatDateTime()
        }
      )
      if (response.status == 200) {
        navigate("/admin/postlist")
      }
    }
    catch (error) {
      console.log(error)
    }
  }
  return (
    <Card>
      <Row>
        <Typography.Title level={4}>{postRelation.length === 0 ? "The article doesn't exist" : "Article details !"}</Typography.Title>
      </Row>
      <Divider />
      <Row>
        <Col span={12}>
          <Typography.Paragraph>
            <Avatar size={40} src={postRelation.user?.image} /> {postRelation.user?.name}
          </Typography.Paragraph>
          <Typography.Paragraph>
            <CalendarOutlined /> {postRelation.post?.createdAt}
          </Typography.Paragraph>
          <Typography.Paragraph>
            Likes: {postRelation.favorites?.length}
          </Typography.Paragraph>
          <Typography.Paragraph>
            Reports: {postRelation.post?.ids.length}
          </Typography.Paragraph>
          <Typography.Paragraph>
            <div>
              <Button type="primary" onClick={showModal}>
                Remove
              </Button>
              <Modal title="Notification" open={isModalOpen} onOk={handleOk} onCancel={handleCancel}>
                <a2>You definitely want to delete this article ?</a2><br />
                Enter the reason:  <input type="text" value={inputValue} onChange={handleInputChange} />
              </Modal>
            </div>
          </Typography.Paragraph>
        </Col>
        <Col span={12}>
          {<Typography.Paragraph>
            Location: {postRelation.post?.location === null ? "########" : postRelation.post?.location}
          </Typography.Paragraph>
          }
        </Col>
      </Row>
      <Divider />
      <Typography.Paragraph>{postRelation.post?.content}</Typography.Paragraph>
      {/* {post.image && <Image src={post.image} width="20%" />} */}
      {postRelation.post?.src === null
        ? postRelation.post?.images.map((item) => {
          return (<Image style={{ margin: 8 }} height='200px' width="20%" src={item.image} />)
        })
        : <video controls style={{ margin: 8 }} height='200px' width="20%" src={postRelation.post?.src} />
      }
    </Card>
  );
};

export default PostDetails;
