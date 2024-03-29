import { Space, Table, Tag } from "antd";
import React, { useEffect, useState } from "react";
import { base_url } from "../config/constant";
import { formatDate } from "../config/constant";
import axios from 'axios';
import { useNavigate } from "react-router-dom";
const PostList = () => {
  const navigate = useNavigate();
  const [posts, setDataPost] = useState([])
  useEffect(() => {
    axios.get(`${base_url}/posts/get-all`)
      .then(response => {
        setDataPost(response.data)
      })
      .catch(error => {
        console.error(error)
      });
  }, [])
  const columns = [
    {
      title: "Post ID",
      dataIndex: "id",
      key: "id",
    },
    {
      title: "Content",
      dataIndex: "content",
      key: "content",
      render: (value) => value === "" ? "########" : value
    },
    {
      title: "Status",
      dataIndex: "status",
      key: "status",
    },
    {
      title: "Create At",
      dataIndex: "createdAt",
      key: "createdAt",
      render: (value) => formatDate(value)
    },
    {
      title: "Images",
      dataIndex: "images",
      key: "images",
      render: (value) => Array.isArray(value) ? value.length : 0
    },
    {
      title: "Video",
      dataIndex: "src",
      key: "src",
      render: (value) => value === null ? 0 : 1
    },
    {
      title: "Location",
      dataIndex: "location",
      key: "location",
      render: (value) => (value === null) || (value === "") ? "########" : value
    },
    {
      title: "Action",
      key: "action",
      dataIndex: "id",
      render: (id) => (
        <Space size="middle">
          <a href="#" onClick={() => navigate(`/admin/postdetail?id=${id}`)}>View</a>
        </Space>
      ),
    },
  ];
  const data = [
    {
      key: "1",
      name: "John Brown",
      age: 32,
      address: "New York No. 1 Lake Park",
      tags: ["nice", "developer"],
    },
    {
      key: "2",
      name: "Jim Green",
      age: 42,
      address: "London No. 1 Lake Park",
      tags: ["loser"],
    },
    {
      key: "3",
      name: "Joe Black",
      age: 32,
      address: "Sydney No. 1 Lake Park",
      tags: ["cool", "teacher"],
    },
  ];
  return <Table columns={columns} dataSource={posts} />;
};

export default PostList;
