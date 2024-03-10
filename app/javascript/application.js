// Entry point for the build script in your package.json
import '@hotwired/turbo-rails'
import './controllers'

import Swiper from 'swiper'
import { Pagination, Navigation, FreeMode, Mousewheel } from 'swiper/modules'
// import Swiper and modules styles
import 'swiper/css/bundle'

// Do not prefetch links when hovering over them
/* eslint-disable no-undef */
Turbo.session.linkPrefetchObserver.stop()

Swiper.use([Pagination, Navigation, FreeMode, Mousewheel])
