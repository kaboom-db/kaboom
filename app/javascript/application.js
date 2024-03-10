// Entry point for the build script in your package.json
import '@hotwired/turbo-rails'
import './controllers'

// Do not prefetch links when hovering over them
Turbo.session.linkPrefetchObserver.stop()

import Swiper from 'swiper'
import { Pagination, Navigation, FreeMode, Mousewheel } from 'swiper/modules'
// import Swiper and modules styles
import 'swiper/css/bundle'

Swiper.use([Pagination, Navigation, FreeMode, Mousewheel])
