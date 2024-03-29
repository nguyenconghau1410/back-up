import React, { useEffect, useState } from "react";
import { Modal, Space, Table, Tag } from "antd";
import { useNavigate } from "react-router-dom";
import axios from 'axios';
import { base_url } from "../config/constant";

const Users = () => {
  const navigate = useNavigate();
  const [dataAPI, setDataAPI] = useState([])
  useEffect(() => {
    axios.get(`${base_url}/users/admin/get-all`)
      .then(response => {
        setDataAPI(response.data)
      })
      .catch(error => {
        console.error(error)
      });
  }, [])
  const [visible, setVisible] = useState(false);
  const [deleteId, setDeleteId] = useState(null);

  const showModal = (id) => {
    setVisible(true);
    setDeleteId(id);
  };

  const handleOk = () => {
    // Thực hiện xóa dữ liệu với ID được chọn (deleteId)
    console.log('Deleting ID:', deleteId);
    setVisible(false);
  };

  const handleCancel = () => {
    setVisible(false);
  };
  const columns = [
    {
      title: "Email",
      dataIndex: "email",
      key: "email",
    },
    {
      title: "Name",
      dataIndex: "name",
      key: "name",
    },
    {
      title: "Gender",
      dataIndex: "gender",
      key: "gender",
      render: (value) => value ? "Nam" : "Nữ"
    },
    {
      title: "Nick name",
      dataIndex: "title",
      key: "title",
    },
    {
      title: "Date Of Birth",
      dataIndex: "dob",
      key: "dob",
    },
    {
      title: "Action",
      key: "action",
      dataIndex: 'id',
      render: (id) => (
        <Space size="middle">
          <a href="#" onClick={() => navigate(`/admin/customer-detail?id=${id}`)}>View</a>
        </Space>
      ),
    },
  ];
  return <Table columns={columns} dataSource={dataAPI} />;
};

export default Users;
