import React from 'react';
import { Flex, Progress } from 'antd';

const ProgressData = () => (
  <Flex gap="small" wrap="wrap" justifyContent="center" >
    <Progress type="circle" percent={75} style={{ margin: '30px', scale: "1.25" }} />
    <Progress type="circle" percent={70} status="exception" style={{ margin: '30px', scale: "1.25" }} />
    <Progress type="circle" percent={100} style={{ margin: '30px', scale: "1.25" }} />
  </Flex>
);

const Dashboard = () => {

}
export default Dashboard
