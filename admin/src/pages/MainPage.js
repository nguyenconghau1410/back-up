import React, { useEffect, useState } from "react";
import { Layout, Menu, Button, theme, Flex, Badge, Dropdown, Drawer, List, Avatar } from "antd";
import { connect } from 'react-redux';
import {
  BarsOutlined,
  DashboardOutlined,
  LogoutOutlined,
  MenuFoldOutlined,
  MenuUnfoldOutlined,
  MessageOutlined,
  PictureOutlined,
  SettingOutlined,
  TeamOutlined,
  UnorderedListOutlined,
  UploadOutlined,
  UserOutlined,
  VideoCameraOutlined,
} from "@ant-design/icons";
import { MdOutlineNotificationsActive } from "react-icons/md";
import { Outlet, useNavigate } from "react-router-dom";
import axios from "axios";
import { base_url, extractId } from "../config/constant";
const { Header, Sider, Content } = Layout;
const MainPage = ({ userData }) => {
  const [collapsed, setCollapsed] = useState(false);
  const navigate = useNavigate();
  const {
    token: { colorBgContainer, borderRadiusLG },
  } = theme.useToken();
  // items for Sidebar

  const [notify, setDataNotify] = useState([])
  useEffect(() => {
    axios.get(`${base_url}/notifications/get-notifications-of-user?userid=${localStorage.getItem('id')}`)
      .then(response => {
        setDataNotify(response.data)
      })
      .catch(error => {
        console.error(error)
      });
  }, [])

  const onLogout = () => {
    navigate("/")
    localStorage.removeItem("id")
    localStorage.removeItem("email")
    localStorage.removeItem("name")
  }
  // items for drop down
  const items = [
    {
      key: "profile",

      label: (
        <span
          onClick={() => navigate("/admin/profile")}
          style={{ textDecoration: " none", border: "none" }}
        >
          <UserOutlined /> Profile
        </span>
      ),
      onclick: () => navigate("/profile"),
    },
    {
      key: "settings",
      label: (
        <span
          onClick={() => navigate("/admin/settings")}
          style={{ textDecoration: " none", border: "none" }}
        >
          <SettingOutlined /> Settings
        </span>
      ),
    },
    {
      key: "logout",
      label: (
        <span
          onClick={() => onLogout()}
          style={{ textDecoration: " none", border: "none" }}
        >
          <LogoutOutlined /> Log out
        </span>
      ),
    },
  ];

  const [open, setOpen] = useState(false);
  const showDrawer = () => {
    setOpen(true);
  };
  const onClose = () => {
    setOpen(false);
  };

  const updateNotify = async (id) => {
    try {
      const response = await axios.put(
        `${base_url}/notifications/mark-as-read?id=${id}`
      )
    }
    catch (error) {
      console.log(error)
    }
  }

  const onTap = (item) => {
    if (!item.read)
      updateNotify(item?.id)
    navigate(`/admin/postdetail?id=${extractId(item?.content)}`)
  }
  const [quantity, setDataQuantiy] = useState([])
  useEffect(() => {
    axios.get(`${base_url}/notifications/count?userid=65fafb24f990482dbe723f04`)
      .then(response => {
        setDataQuantiy(response.data)
      })
      .catch(error => {
        console.error(error)
      });
  })

  useEffect(() => {
    console.log('userData:', userData);
  }, [userData]);

  return (
    <Layout>
      <Sider trigger={null} collapsible collapsed={collapsed}>
        <div
          style={{
            height: 62,
            backgroundColor: "gray",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
          }}
          className="demo-logo-vertical"
        >
          <h3 style={{ color: "white", fontSize: "18px" }}>ZNet</h3>
        </div>
        <Menu
          theme="dark"
          mode="inline"
          onClick={({ key }) => {
            if (key === "logout") {
            } else {
              navigate(key);
            }
          }}
          defaultSelectedKeys={["1"]}
          items={[
            {
              key: "/admin",
              icon: <DashboardOutlined />,
              label: "Dashboard",
            },
            {
              key: "user",

              icon: <TeamOutlined />,
              label: "Users",
            },
            {
              key: "post",
              icon: <UnorderedListOutlined />,
              label: "Post manage",
              children: [
                {
                  key: "postlist",
                  icon: <BarsOutlined />,
                  label: "List post",
                },
              ],
            },
            // {
            //   key: "chat",
            //   icon: <MessageOutlined />,
            //   label: "Chat",
            // },
            // {
            //   key: "settings",
            //   icon: <SettingOutlined />,
            //   label: "Settings",
            // },
          ]}
        />
      </Sider>
      <Layout>
        <Header
          style={{
            padding: 0,
            background: colorBgContainer,
            display: "flex",
            justifyContent: "space-between",
          }}
        >
          <Button
            type="text"
            icon={collapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
            onClick={() => setCollapsed(!collapsed)}
            style={{
              fontSize: "16px",
              width: 64,
              height: 64,
            }}
          />
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <div onClick={showDrawer} style={{ display: "flex", marginRight: 20 }}>
              <Badge count={quantity.count}>
                <MdOutlineNotificationsActive size={25} />
              </Badge>
            </div>
            <Drawer title="Znet notification" onClose={onClose} open={open}>
              <List
                itemLayout="horizontal"
                dataSource={notify}
                renderItem={(item, index) => (
                  <List.Item>
                    <List.Item.Meta
                      avatar={<Avatar src={`https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFvO1F2BSKNjmZ45H_ybXSfzFViKOkhf8sREZLB3Vuxk-jNHD9-uSIBoqvWhsYXN1xu0Q&usqp=CAU`} />}
                      title={<a href="#" style={{ color: item.read ? "grey" : "black" }} onClick={() => onTap(item)}>{item.content}</a>}
                    />
                  </List.Item>
                )}
              />
            </Drawer>
            <Dropdown menu={{ items }} placement="bottom" arrow>
              <div style={{ display: "flex", alignItems: "center" }}>
                <img
                  width={32}
                  height={32}
                  src="data:image/jpeg;base64,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"
                  alt=""
                />
                <div
                  style={{
                    display: "flex",
                    flexDirection: "column",
                    lineHeight: 1.5,
                    margin: 8,
                  }}
                >
                  <b className="">{localStorage.getItem("name")}</b>
                  <span className="">{localStorage.getItem("email")}</span>
                </div>
              </div>
            </Dropdown>
          </div>
        </Header>
        <Content
          style={{
            margin: "24px 16px",
            padding: 24,
            minHeight: 280,
            background: colorBgContainer,
            borderRadius: borderRadiusLG,
          }}
        >
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  );
};

const mapStateToProps = (state) => ({
  userData: state.auth.userData,
});

export default MainPage;
