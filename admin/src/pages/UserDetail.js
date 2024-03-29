import React, { useEffect, useState } from "react";
import { Avatar, Typography, Row, Col, Divider, Card, Button, Modal } from "antd";
import { UserOutlined } from "@ant-design/icons";
import ImageList from '@mui/material/ImageList';
import ImageListItem from '@mui/material/ImageListItem';
import queryString from "query-string";
import axios from "axios";
import { base_url } from "../config/constant";
import { Navigate, useNavigate } from "react-router-dom";
const { Title, Text } = Typography;

export const UserDetail = () => {
  const navigate = useNavigate();
  const id = queryString.parse(window.location.search).id;
  const [dataAPI, setDataAPI] = useState([])
  const [imageList, setDataImage] = useState([])
  const [following, setDataFollowing] = useState([])
  const [follower, setDataFollower] = useState([])
  const [post, setDataPost] = useState([])
  useEffect(() => {
    axios.get(`${base_url}/find/${id}`)
      .then(response => {
        setDataAPI(response.data)
      })
      .catch(error => {
        console.error(error)
      });
  }, [])
  useEffect(() => {
    axios.get(`${base_url}/images/get-by-userid/${id}`)
      .then(response => {
        setDataImage(response.data)
      })
      .catch(error => {
        console.error(error)
      });
  }, [])
  useEffect(() => {
    axios.get(`${base_url}/following/get-userid/${id}`)
      .then(response => {
        setDataFollowing(response.data)
      })
      .catch(error => {
        console.error(error)
      });
  }, [])
  useEffect(() => {
    axios.get(`${base_url}/following/get-following/${id}`)
      .then(response => {
        setDataFollower(response.data)
      })
      .catch(error => {
        console.error(error)
      });
  }, [])
  useEffect(() => {
    axios.get(`${base_url}/posts/count?userid=${id}`)
      .then(response => {
        setDataPost(response.data)
      })
      .catch(error => {
        console.error(error)
      });
  }, [])

  const [isModalOpen, setIsModalOpen] = useState(false);
  const showModal = () => {
    setIsModalOpen(true);
  };
  const handleOk = () => {
    setIsModalOpen(false);
    deleteUser(dataAPI.id)
  };
  const handleCancel = () => {
    setIsModalOpen(false);
  };

  const deleteUser = async (userId) => {
    try {
      const response = await axios.delete(
        `${base_url}/users/delete?id=${userId}`
      );
      if (response.status == 200) {
        alert("Delete success !")
        navigate("/admin/user")
      }
      else {
        alert("There was an error, try it again !")
      }
    }
    catch (error) {
      console.log(error)
    }
  }

  return (
    <div style={{ padding: "20px" }}>
      <Row gutter={[16, 16]}>
        <Col span={8} style={{ textAlign: "center" }}>
          <Avatar size={120} src={dataAPI.image} />
          <Title level={4} style={{ marginTop: "10px" }}>
            {dataAPI.email}
          </Title>
          <Row style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <Col>
              <Title style={{ margin: '0 10px' }} level={5}>Post: {post.count}</Title>
            </Col>
            <Col>
              <Title style={{ margin: '0 10px' }} level={5}>Follower: {follower.length}</Title>
            </Col>
            <Col>
              <Title style={{ margin: '0 10px' }} level={5}>Following: {following.length}</Title>
            </Col>
          </Row>
          <Typography.Paragraph style={{ marginTop: "20px" }}>
            <div>
              <Button type="primary" onClick={showModal}>
                Remove
              </Button>
              <Modal title="Notification" open={isModalOpen} onOk={handleOk} onCancel={handleCancel}>
                <a2>You definitely want to delete this user ?</a2><br />
              </Modal>
            </div>
          </Typography.Paragraph>
        </Col>
        <Col span={16}>
          <Card>
            <Row gutter={16}>
              <Col span={12}>
                <Title level={5}>Name: {dataAPI.name}</Title>
              </Col>
              <Col span={12}>
                <Title level={5}>Nickname: {dataAPI.title}</Title>
              </Col>
            </Row>
            <Row gutter={16}>
              <Col span={12}>
                <Title level={5}>Date of birth: {dataAPI.dob}</Title>
              </Col>
              <Col span={12}>
                <Title level={5}>Status: {dataAPI.status}</Title>
              </Col>
            </Row>
          </Card>
          <Card>
            <ImageList sx={{ width: 700, height: 450 }} cols={5} rowHeight={164}>
              {imageList.map((item) => (
                <ImageListItem key={item.image}>
                  <img
                    srcSet={`${item.image}?w=164&h=164&fit=crop&auto=format&dpr=2 2x`}
                    src={`${item.image}?w=164&h=164&fit=crop&auto=format`}
                    loading="lazy"
                  />
                </ImageListItem>
              ))}
            </ImageList>
          </Card>
        </Col>
      </Row>
    </div>
  );
};

export default UserDetail;
