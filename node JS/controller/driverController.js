const User=require('../models/users');
const Driver=require('../models/driver');
const { validationResult } = require('express-validator');
const fs = require('fs');
const path = require('path');
