import React, { useState, useEffect } from "react";
import { Form, Input, Button, Card } from "antd";
import { UserOutlined, LockOutlined } from "@ant-design/icons";
import { useNavigate } from "react-router-dom";
import { connect } from 'react-redux';
import axios from "axios";
import { base_url } from "../config/constant";

const Login = () => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();
  const onFinish = () => {
    navigate("/admin");
  };

  const handleLogin = async () => {
    try {
      const response = await axios.post(
        `${base_url}/auth/login`,
        {
          "email": username.trim(),
          "password": password.trim()
        }
      )
      if (response.status === 200) {
        const data = response.data
        if (data.role?.code === "ADMIN") {
          onFinish()
          localStorage.setItem("id", data.id)
          localStorage.setItem("email", data.email)
          localStorage.setItem("name", data.name)
        }
        else if (data.role?.code === "USER") {
          alert("Permission denied !")
        }
        else {
          alert("Email or password invalid !")
        }
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
    <div
      style={{
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        height: "100vh",
        backgroundColor: "gray",
      }}
      className="login-container"
    >
      <Card
        style={{
          width: 300,
          height: "fit-content",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          margin: " auto",
        }}
      >
        <Form
          name="login-form"
          // onFinish={onFinish}
          initialValues={{ remember: true }}
        >
          <Form.Item
            name="username"
            rules={[
              { required: true, message: "Vui lòng nhập tên đăng nhập!" },
            ]}
          >
            <Input
              prefix={<UserOutlined />}
              placeholder="Tên đăng nhập"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
            />
          </Form.Item>
          <Form.Item
            name="password"
            rules={[{ required: true, message: "Vui lòng nhập mật khẩu!" }]}
          >
            <Input
              prefix={<LockOutlined />}
              type="password"
              placeholder="Mật khẩu"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </Form.Item>
          <Form.Item>
            <Button onClick={handleLogin} type="primary" htmlType="submit">
              Đăng nhập
            </Button>
          </Form.Item>
        </Form>
      </Card>
    </div>
  );
};

export default Login;
