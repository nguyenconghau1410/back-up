import "./App.css";
import { Route, BrowserRouter as Router, Routes } from "react-router-dom";
import MainPage from "./pages/MainPage";
import Users from "./pages/Users";
import PostList from "./pages/PostList";
import Settings from "./pages/Settings";
import Login from "./pages/Login";
import ForgotPassword from "./pages/ForgotPassword";
import Chat from "./pages/Chat";
import PostDetails from "./pages/PostDetails";
import Profile from "./pages/Profile";
import Dashboard from "./pages/Dashboard";
import UserDetail from "./pages/UserDetail";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/forgotpassword" element={<ForgotPassword />} />
        <Route path="/admin" element={<MainPage />}>
          <Route path="chat" element={<Chat />} />
          <Route index element={<Dashboard />} />
          <Route path="settings" element={<Settings />} />
          <Route path="user" element={<Users />} />
          <Route path="postlist" element={<PostList />} />
          <Route path="profile" element={<Profile />} />
          <Route path="postdetail" element={<PostDetails />} />
          <Route path="customer-detail" element={<UserDetail />} />
        </Route>
      </Routes>
    </Router>
  );
}

export default App;
